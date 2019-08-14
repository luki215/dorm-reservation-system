class ReservationsController < ApplicationController
  before_action :set_place, only: [:create, :destroy]

  def create
    existing_place = current_user.place
    begin
    Place.transaction do 
      existing_place.user = nil if existing_place
      @place.user = current_user
      existing_place.save! if existing_place
      @place.save!
    end
    rescue ActiveRecord::RecordInvalid
      errors = @place.errors 
    end
    
    # current_user.save!
    @place.touch
    err_to_render = "Reservation not successfull - sex mismatch" if errors && errors[:sex]
    redirect_back(fallback_location: places_path, alert: err_to_render)
  end

  def create_for_alliance
    cell = params[:cell]
    if AppSetting.first.current_round == :fourth or AppSettings.first.current_round == :third && curent_user.place&.cell == cell
      @alliance = Aliance.find(params[:aliance_id]) 
      @places_on_cell = Place.where(cell: cell).to_a
      users = @alliance.users.to_a

      has_girls = false
      has_boys = false
      refuses_girls = false
      refuses_boys = false

      #First we need to know if there are any boys or girls on the cell and if the cell allows these to move in. We also prepare an array for descriptions

      place_description = []

      for bed in @places_on_cell
        if !bed.user.nil?
          if bed.user.male
            has_boys = true
            if bed.user.same_sex_cell
              refuses_girls = true
            end
          else
            has_girls = true
            if bed.user.same_sex_cell
              refuses_boys = true
            end
          end
        end
        place_description.push(0)
      end

      #then we generate a description for each place and then delete the taken ones
      #description of place is a number between 0 and 15, and bits from lowest to highest are zero if: Said place accepts males, Said place accepts females, place doesnt have a female in the same room, place doesnt havea male in the same room.

      i=0
      while i< @places_on_cell.size
        if !@places_on_cell[i].user.nil?
          user_characteristic = (@places_on_cell[i].user.same_sex_room ? 5 : 4) * (@places_on_cell[i].user.male ? 2 : 1) #4 possible values, 4 for male accepting females, 5 for females that do not accept males, 8 for males who accept females and 10 for males who doesnt 
          j=0
          while j<@places_on_cell.size
            if @places_on_cell[i].room == @places_on_cell[j].room
              place_description[j] = place_description[j] | user_characteristic
            end 
            j = j + 1
          end
          @places_on_cell.delete_at(i)
          place_description.delete_at(i)
        else
          i = i + 1
        end
      end 

      i=0
      while i<users.size #remove users that already live on said cell or are unsuitable for cell
        if users[i].place&.cell == cell or users[i].male && refuses_boys or users[i].male && users[i].same_sex_cell && has_girls or !users[i].male && refuses_girls or !users[i].male && users[i].same_sex_cell && has_boys 
          users.delete_at(i)
        else
          i = i+1
        end
      end

      #Generate for each user his description. Description is number between 1 and 15, where bits from lowest to highest are one if: Said user is male, said user is female, said user is unwilling to live with female, and unwilling to live with male
      #Also prepare position array and placement array
      user_position = []
      users_description = []
      i=0
      while i<users.size
        if users[i].male
          users_description.push(1 + (users[i].same_sex_room ? 4 : 0))
        else
          users_description.push(2 + (users[i].same_sex_room ? 8 : 0))
        end
        user_position.push(-1)
        i = i + 1
      end
      
      #prepare room_free array
      room_free = []
      for bed in @places_on_cell
        room_free.push(true)
      end

      target = users.size < @places_on_cell.size ? users.size : @places_on_cell.size #Guess hhe maximal amount of people for which we can hope to find a spot
      users_placed = 0
      
        while users_placed < target #at most two iterations, because target for second iteration is best value from first
        best = 0
        user_tested = 0
        while user_tested > -1  #And here goes backtracking
          user_position[user_tested] = user_position[user_tested] + 1
          if user_position[user_tested] == @places_on_cell.size #We have checked all possible positions for user -- need to backtrack
            user_position[user_tested] == -1
            user_tested == user_tested - 1
            room_free[user_position[user_tested]] = true if user_tested != -1
            users_placed = users_placed - 1 if users_placed != 0
          elsif room_free[user_position[user_tested]] && can_live?(users_description[user_tested],users[user_tested].room_type,place_description[user_position[user_tested]],@places_on_cell[user_position[user_tested]].room_type) #We have found new suitable position for a user
            room_free[user_position[user_tested]] = false
            users_placed = users_placed + 1
            break if users_placed == target
            best = users_placed if users_placed > best
            user_tested = user_tested + 1
          end
        end        
        target = best
      end
      
      found_place_for_boys = false
      found_place_for_girls = false
      
      i=0
      while i<users.size
        found_place_for_girls = true if user_position[i]!=-1 and !users[i].male
        found_place_for_boys = true if user_position[i]!=-1 and users[i].male
        i = i + 1
      end
      
      need_reset_cell_preferences =  found_place_for_boys && found_place_for_girls

      people_on_rooms = []
      i = 0
      while i<users.size
        people_on_rooms.push(@places_on_cell[user_position[i]].room) if user_position[i]!= -1
        users[i].same_sex_cell=false if user_position[i]!= -1 && need_reset_cell_preferences
        users[i].save if user_position[i]!= -1 && need_reset_cell_preferences
        people_on_rooms.push(-1) if user_position[i]== -1
        i = i + 1
      end

      i=0
      moved = 0
      while i<users.size # now for all users that dont have position=-1, that means we found a spot for them, we need to change their sex preferences and actually put them on their new spot.
        j = i+1
        while j < users.size
          if people_on_rooms[i]!= -1 && people_on_rooms[i] == people_on_rooms[j] && (users[i].male != users[j].male)
            users[i].same_sex_room = false
            users[j].same_sex_room = false
            users[i].save
            users[j].save
          end
          j = j + 1
        end
        former_place = users[i].place
        former_place.user = nil if user_position[i]!= -1
        moved = moved + 1 if user_position[i]!= -1
        former_place.save if user_position[i] != -1
        @places_on_cell[user_position[i]].user = users[i] if user_position[i]!=-1
        @places_on_cell[user_position[i]].save if user_position[i]!=-1
        i = i + 1
      end
    redirect_back(fallback_location: places_path, notice: t("reservation.alliance_moved") + " " + moved.to_s + " " + t("reservation.out_of") + " " + @alliance.users.size.to_s + " " + t("reservation.members"))
    end
  end

  def destroy
    current_user.place&.touch
    current_user.place = nil
    current_user.save!
    redirect_back(fallback_location: places_path)
  end

  private
  def set_place
    @place = Place.find(params[:place_id])
  end

  def can_live?(user,user_room_type,room,room_room_type) #takes description and room types, note that the descriptions were forged in a way that user can live on a place if their desription never has an one on the same position.
    ((user & room) == 0) and (user_room_type == room_room_type)
  end
end
