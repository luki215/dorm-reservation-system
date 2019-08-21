namespace :generators do
    desc "Generate Users"
    task :users => :environment do
        puts "Generating users..."
        User.transaction do
          File.open("tmp/users.csv", "r").each_line do |line|
              data = line.split(":")

              begin
                u = User.create!(
                      {
                          email: data[0],
                          password: "123456",
                          fullname: data[2],
                          male: data[3] == "Muz",
                          room_type: data[1]
                      }
                )
                place_primary = find_place(data[4], :primary)
                place_secondary = find_place(data[5], :secondary)

                place_primary&.primary_claim = u 
                place_primary&.save!
                place_secondary&.secondary_claim = u 
                place_secondary&.save!

              rescue
                puts "fail for #{data[0]}"
                raise
              end
          end
        end
        puts "Generated successfully"
    end

    def find_place(room, claim)
      room = room.strip
      if room.blank?
        nil
      else
        case claim
          when :primary
            place = Place.where(room: room, primary_claim: nil).first
          when :secondary
            place = Place.where(room: room, secondary_claim: nil).first
        end

        if place.nil?
          puts "W: Ignoring room #{room} #{claim}"
        end
        place
      end
    end
end