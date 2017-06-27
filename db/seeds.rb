# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#####################
## Stage
#####################
puts "Loading Stages"
Stage.delete_all
Stage.create(:id => 1, :sort_order => 1, :name => 'Idea Development')
Stage.create(:id => 2, :sort_order => 2, :name => 'Preliminary Research')
Stage.create(:id => 3, :sort_order => 3, :name => 'Fundraising')
Stage.create(:id => 4, :sort_order => 4, :name => 'Concept/Planning/Research')
Stage.create(:id => 5, :sort_order => 5, :name => 'Implementation')
Stage.create(:id => 6, :sort_order => 6, :name => 'Feedback/Changes')
Stage.create(:id => 7, :sort_order => 7, :name => 'Post Implementation Activities')

#####################
## Project Types
#####################
puts "Loading Project Types"
ProjectType.delete_all
ProjectType.create(:id => 1, :name => 'Animation')
ProjectType.create(:id => 2, :name => 'Event')
ProjectType.create(:id => 3, :name => 'Factograph')
ProjectType.create(:id => 4, :name => 'GIF')
ProjectType.create(:id => 5, :name => 'Fundraising')
ProjectType.create(:id => 6, :name => 'Infographic')
ProjectType.create(:id => 7, :name => 'Interactive')
ProjectType.create(:id => 8, :name => 'Internal Meeting')
ProjectType.create(:id => 9, :name => 'Learning')
ProjectType.create(:id => 10, :name => 'Managing/Developing')
ProjectType.create(:id => 11, :name => 'Newsletter')
ProjectType.create(:id => 12, :name => 'Outreach')
ProjectType.create(:id => 13, :name => 'Radio Story')
ProjectType.create(:id => 14, :name => 'StoryBuilder Story')
ProjectType.create(:id => 15, :name => 'Support')
ProjectType.create(:id => 16, :name => 'Teaching')
ProjectType.create(:id => 17, :name => 'Web Application')
ProjectType.create(:id => 18, :name => 'Website')
ProjectType.create(:id => 19, :name => 'Other')
ProjectType.create(:id => 20, :name => 'Design')

#####################
## Organizations
#####################
puts "Loading Organizations"
Organization.delete_all
Organization.create(id: 1, long_name: 'ForSet', short_name: 'FS')
Organization.create(id: 2, long_name: "UNICEF", short_name: 'UNICEF')
Organization.create(id: 3, long_name: 'UNDP', short_name: 'UNDP')
Organization.create(id: 4, long_name: 'UNFPA', short_name: 'UNFPA')
Organization.create(id: 5, long_name: 'Eurasianet', short_name: 'Eurasia')
Organization.create(id: 6, long_name: 'OSGF', short_name: 'OSGF')
Organization.create(id: 7, long_name: 'Liberali', short_name: 'Liberali')
Organization.create(id: 8, long_name: 'TBC', short_name: 'TBC')
Organization.create(id: 9, long_name: 'MAC Georgia', short_name: 'MAC')
Organization.create(id: 10, long_name: 'EWMI', short_name: 'EWMI')
Organization.create(id: 11, long_name: 'NED', short_name: 'NED')
Organization.create(id: 12, long_name: 'CENN', short_name: 'CENN')


#####################
## Projects
#####################
puts "Loading Projects"
Project.delete_all
Project.create(id: 1, name: 'Branding', organization_id: 1, active: true)
Project.create(id: 2, name: 'Census Visuals', organization_id: 4, active: true)
Project.create(id: 3, name: 'IT Support', organization_id: 1, active: true)


#####################
## Activities
#####################
puts "Loading Activities"
Activity.delete_all
Activity.create(id: 1, name: 'Create Branding', project_id: 1, project_type_id: 20, active: true)
Activity.create(id: 2, name: 'Create Social Meida Account', project_id: 1, project_type_id: 12, active: true)
Activity.create(id: 3, name: 'Proposal', project_id: 2, project_type_id: 10, active: true)
Activity.create(id: 4, name: 'Youth - Monograph Analysis', project_id: 2, project_type_id: 10, active: true)
Activity.create(id: 5, name: 'Youth - Fact Concepts', project_id: 2, project_type_id: 10, active: true)
Activity.create(id: 6, name: 'Youth - Animation Concepts', project_id: 2, project_type_id: 10, active: true)
Activity.create(id: 7, name: 'Youth - Facts', project_id: 2, project_type_id: 3, active: true)
Activity.create(id: 8, name: 'Youth - Animations', project_id: 2, project_type_id: 1, active: true)
Activity.create(id: 9, name: 'Hours App', project_id: 3, project_type_id: 18, active: true)
Activity.create(id: 10, name: 'Trello', project_id: 3, project_type_id: 10, active: true)
Activity.create(id: 11, name: 'Computer Help', project_id: 3, project_type_id: 19, active: true)


#####################
## TimeStamps
#####################
puts "Reset TimeStamps"
Timestamp.delete_all

# #####################
# ## Pages
# #####################
# puts "Loading Pages"
# Page.delete_all
# PageTranslation.delete_all
# p = Page.create(:id => 1, :name => 'about')
# p.page_translations.create(:locale => 'en', :title => 'About Bootstrap Starter Project', :content => 'You have run rake db:seed and this is an example of translated content. Click the Language Switcher link in the top-right corner to view the text in another language.')
# p.page_translations.create(:locale => 'ka', :title => "'Bootstrap Starter' პროექტის შესახებ", :content => "თქვენ ჩაუშვით 'rake db:seed' და ეს არის კონტენტის თარგმანის მაგალით. ტექსტის სხვა ენაზე სანახავად დააჭირეთ ენის გადამრთველის ბმულს მარჯვენა ზედა კუთხეში.")

