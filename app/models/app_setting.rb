class AppSetting < ApplicationRecord

  enum dorm: [ :listopad, :kajka ]

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

    def current_round_numeric
        if DateTime.now < first_round_start
          return 0
        elsif DateTime.now < second_round_start
          return 1
        elsif DateTime.now < third_round_start
          return 2
        elsif DateTime.now < fourth_round_start
          return 3
        else
          return 4
        end  
    end
end
