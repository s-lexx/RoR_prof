# frozen_string_literal: true

require_relative 'lib/railway'

Railway::Task.new(app_dir: __dir__).start
