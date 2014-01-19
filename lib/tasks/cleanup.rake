namespace :cleanup do
  task run: :environment do
		puts 'Delete links that are 14 days or older and not permanent.'
		Link.where("created_at < ? AND permanent = ?", 14.days.ago, false).destroy_all
  end
end
