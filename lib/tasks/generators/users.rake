namespace :generators do
    desc "Generate Users"
    task :users => :environment do
        puts "Generating users..."
        User.transaction do
            File.open("tmp/users.csv", "r").each_line do |line|
                data = line.split(":")
                begin 
                    User.create!(
                        {
                            email: data[0], 
                            password: "123456",
                            fullname: data[2],
                            male: data[3] == "Muz",
                            primary_claim: data[4] == "" ? nil : Place.where(room: data[4]).first,
                            secondary_claim: data[5] == "" ? nil : Place.where(room: data[5]).first,
                            room_type: data[1]
                        }
                    )
                rescue
                    puts "fail for #{data[0]}"
                    raise
                end
            end
        end
        puts "Generated successfully"
    end
end
