class AppSetting < ApplicationRecord

    def current_round
        :before if DateTime.now < first_round_start
        :first if DateTime.now < second_round_start
        :second if DateTime.now < third_round_start
        :third if DateTime.now < fourth_round_start
        :fourth
        
    end
end
