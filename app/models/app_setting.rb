class AppSetting < ApplicationRecord

    def current_round
        if DateTime.now < first_round_start
          return :before
        elsif DateTime.now < second_round_start
          return :first
        elsif DateTime.now < third_round_start
          return :second
        elsif DateTime.now < fourth_round_start
          return :third
        else
          return :fourth
        end  
    end
end
