# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#####################
## Project Types
#####################
puts "Loading Project Types"
ProjectType.delete_all
ProjectType.create(:id => 1, :name => 'Application')
ProjectType.create(:id => 2, :name => 'Meeting')
ProjectType.create(:id => 3, :name => 'Infographic')
ProjectType.create(:id => 4, :name => 'Interactive')
ProjectType.create(:id => 5, :name => 'Factograph')
ProjectType.create(:id => 6, :name => 'Workshop')
ProjectType.create(:id => 7, :name => 'Training')
ProjectType.create(:id => 8, :name => 'Conference')
ProjectType.create(:id => 9, :name => 'Comic')

#####################
## Stage
#####################
puts "Loading Stages"
Stage.delete_all
Stage.create(:id => 1, :sort_order => 1, :name => 'Pre-concept')
Stage.create(:id => 2, :sort_order => 2, :name => 'Concept/Planning/Research')
Stage.create(:id => 4, :sort_order => 3, :name => 'Implementation')
Stage.create(:id => 5, :sort_order => 4, :name => 'Feedback/Changes')
Stage.create(:id => 6, :sort_order => 5, :name => 'Post Implementation Activities')


#####################
## Organizations
#####################
puts "Loading Organizations"
Organization.delete_all
Organization.create(id: 1, long_name: 'JumpStart Georgia', short_name: 'JS')
Organization.create(id: 2, long_name: 'Article 42 of the Constitution', short_name: 'A42')
Organization.create(id: 3, long_name: 'Chai Khana', short_name: 'Chai Khana')
Organization.create(id: 4, long_name: 'Open Society Foundations', short_name: 'OSF')
Organization.create(id: 5, long_name: 'Transparency International Secretariat', short_name: 'TI Sec')
Organization.create(id: 6, long_name: "United Nations Children's Fund", short_name: 'UNICEF')
Organization.create(id: 7, long_name: 'United Nations Development Fund', short_name: 'UNDP')
Organization.create(id: 8, long_name: 'United Nations Population Fund', short_name: 'UNFPA')

  
#####################
## Projects
#####################
puts "Loading Projects"
Project.delete_all
Project.create(id: 1, name: 'The Hours', organization_id: 1, project_type_id: 1, active: true)
Project.create(id: 2, name: 'Choosing Male', organization_id: 3, project_type_id: 4, active: true)
Project.create(id: 3, name: 'Website', organization_id: 3, project_type_id: 1, active: true)
Project.create(id: 4, name: 'Data Portal', organization_id: 6, project_type_id: 1, active: true)
Project.create(id: 5, name: 'Ethnic Minorities in S. Causasus', organization_id: 3 , project_type_id: 3, active: true)



# #####################
# ## Pages
# #####################
# puts "Loading Pages"
# Page.delete_all
# PageTranslation.delete_all
# p = Page.create(:id => 1, :name => 'about')
# p.page_translations.create(:locale => 'en', :title => 'About Bootstrap Starter Project', :content => 'You have run rake db:seed and this is an example of translated content. Click the Language Switcher link in the top-right corner to view the text in another language.')
# p.page_translations.create(:locale => 'ka', :title => "'Bootstrap Starter' პროექტის შესახებ", :content => "თქვენ ჩაუშვით 'rake db:seed' და ეს არის კონტენტის თარგმანის მაგალით. ტექსტის სხვა ენაზე სანახავად დააჭირეთ ენის გადამრთველის ბმულს მარჯვენა ზედა კუთხეში.")

