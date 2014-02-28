namespace :core do
  desc "Generates d360 default data"
  task "seed" => :environment do |t, args|
    Rake::Task["core:seed_permissions"].invoke
    Rake::Task["core:seed_system_admin"].invoke
  end

  desc "Generates admin"
  task "seed_system_admin", [:email,:password] => :environment do |t, args|

    email = args[:email] || "admin@publish-it.com"
    pwd = args[:password] || "SYSADMIN"

    puts "Creating SYSADMIN user"

    user = User.find_or_create_by_email(email)
    user.name = 'PublishIT Admin'
    user.password = "SYSADMIN"
    user.save

    role = Role.find_by_name(User::ROLE[:ADMIN])

    user.roles << role

    puts "Created SYSADMIN user"

  end

  desc "Generates default permissions"
  task "seed_permissions" => :environment do |t, args|

    puts "Creating permissions"

    admin_role = Role.find_or_create_by_name(User::ROLE[:ADMIN])

    editor_role = Role.find_or_create_by_name(User::ROLE[:EDITOR])
    reporter_role = Role.find_or_create_by_name(User::ROLE[:REPORTER])
    guest_role = Role.find_or_create_by_name(User::ROLE[:GUEST])

    create_new_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:CREATE],
                                                           :model_name => :ARTICLE)

    reporter_role.permissions << create_new_article unless reporter_role.permissions.include? create_new_article

    edit_any_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:EDIT],
                                                         :model_name => :ARTICLE)

    reporter_role.permissions << edit_any_article unless reporter_role.permissions.include? edit_any_article

    delete_any_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:DELETE],
                                                           :model_name => :ARTICLE)
    editor_role.permissions << delete_any_article unless editor_role.permissions.include? delete_any_article

    publish_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:PUBLISH],
                                                        :model_name => :ARTICLE)

    editor_role.permissions << publish_article unless editor_role.permissions.include? publish_article

    comment_on_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:COMMENT],
                                                           :model_name => :ARTICLE)
    editor_role.permissions << comment_on_article  unless editor_role.permissions.include? comment_on_article
    reporter_role.permissions << comment_on_article unless reporter_role.permissions.include? comment_on_article

    view_completed_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:COMPLETED],
                                                               :model_name => :ARTICLE)

    view_any_article = Permission.find_or_create_by_name(User::PERMISSIONS[:ARTICLE][:VIEW],
                                                         :model_name => :ARTICLE)

    editor_role.permissions << view_completed_article unless editor_role.permissions.include? view_completed_article

    editor_role.permissions << view_any_article unless editor_role.permissions.include? view_any_article
    reporter_role.permissions << view_any_article unless reporter_role.permissions.include? view_any_article
    guest_role.permissions << view_any_article unless guest_role.permissions.include? view_any_article
    admin_role.permissions << view_any_article unless admin_role.permissions.include? view_any_article

    update_user_role  = Permission.find_or_create_by_name(User::PERMISSIONS[:USER][:UPDATE],
                                                          :model_name => :USER)

    admin_role.permissions << update_user_role unless admin_role.permissions.include? update_user_role

    puts "Created permissions"
  end
end