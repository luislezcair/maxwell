# frozen_string_literal: true

namespace :seeds do
  desc 'Create admin user'

  task admin_user: :environment do
    ActiveRecord::Base.transaction do
      if User.find_by(username: 'admin')
        puts 'El usuario admin ya existe'
      else
        g = Group.find_or_create_by(name: 'Administradores', admin: true)
        g.users.create!(email: 'admin@example.com',
                        active: true,
                        firstname: 'admin',
                        lastname: 'admin',
                        username: 'admin',
                        password: 'admin-123',
                        password_confirmation: 'admin-123')
      end
    end
  end
end
