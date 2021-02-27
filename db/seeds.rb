# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# admin_users = AdminUser.create([
#     {username: "addy@novi.nl", password: "novi!0033"},
#     {username: "bart@novi.nl", password: "novi!0033"},
#     {username: "coen@novi.nl", password: "novi!0033"},
#     {username: "dirk@novi.nl", password: "novi!0033"}])

# api_user = ApiUser.create([
#     {username: "alex@inholland.nl", password: "novi!0033", customer_id: 3, can_add_users: true}])

# customers = Customer.create([
#     {name: "Novi Hogeschool", deleted: false}])

# qualification_types = QualificationType.create([
#     {description: "Diploma"},
#     {description: "Certificaat"}])

# qualifications = Qualification.create([
#     {qualification_type_id: 1, name: "HBO Informatica", organization: "Hogeschool Leiden"},
#     {qualification_type_id: 1, name: "HBO-V", organization: "Diverse"},
#     {qualification_type_id: 2, name: "MCSA", organization: "Microsoft"},
#     {qualification_type_id: 1, name: "HAVO Natuur en Techniek", organization: "Diverse"},
#     {qualification_type_id: 1, name: "VWO Economie en Maatschappij", organization: "Diverse"},
#     {qualification_type_id: 2, name: "MCSE", organization: "Microsoft"},
#     {qualification_type_id: 2, name: "MC-ITP", organization: "Microsoft"},
#     {qualification_type_id: 2, name: "Azure Developer Associate", organization: "Microsoft"},
#     {qualification_type_id: 2, name: "Developer Associate", organization: "Microsoft"},
#     {qualification_type_id: 2, name: "CCNA", organization: "Cisco"},
#     {qualification_type_id: 2, name: "CCNP", organization: "Cisco"},
#     {qualification_type_id: 2, name: "CCNP", organization: "Cisco"},
#     {qualification_type_id: 2, name: "CCA", organization: "Citrix"},
#     {qualification_type_id: 2, name: "CCE", organization: "Citrix"},
#     {qualification_type_id: 2, name: "CCIA", organization: "Citrix"},
#   ])

courses = Course.create([
  {name: "Finance", code: "FIN", customer_id: 2},
  {name: "Database Ontwikkeling", code: "DON", customer_id: 2},
  {name: "Data Analyse met R", code: "DAR", customer_id: 2},
])