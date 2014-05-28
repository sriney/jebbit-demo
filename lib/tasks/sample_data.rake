
require_relative "../../app/models/site"

namespace :db do
  desc "Filling database with sample data for development. Pass --force to delete a production database"
  task :populate, [:force] => [:environment] do |t, args|
    if Rails.env.production? && args[:force] != "--force"
      raise "\nIf you wish to run rake db:populate in production, run like 'rake db:populate[--force]\n"
    end
    Rake::Task['db:schema:load'].invoke
    load_data
  end
end

def load_data
  load_1
  load_2
end


# Not using yaml b/c of no support for here-is docs
def load_1
  puts "created Revs"
  p = Site.new
  p.name = "Revs"
  p.author = "Jebbit"
  p.created_at = Date.new 2014, 05, 27 
  p.img_url = "http://image_somewhere.com/img.jpg"
  p.landing_url = "http://jebbit.com"
  p.save!
end

def load_2
  puts "created Bruins"
  p = Site.new
  p.name = "Bruins"
  p.author = "Jebbit"
  p.created_at = Date.new 2014, 05, 27 
  p.img_url = "http://image_somewhere.com/img.jpg"
  p.landing_url = "http://google.com"
  p.save!
end
