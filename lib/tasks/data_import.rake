require 'rest_client'
require 'import/importer'
require 'import/fitness_info_transformer'
require 'import/fitness_info_datasource'
require 'import/fitnes_si_transformer'
require 'import/fitnes_si_datasource'
require 'import/slovenia_wellness'
require 'import/fitness_info_wellness'
require 'import/fitnes_si_new'

namespace :import do

  # TODO: metaprogram this thing

  desc "Import fitness data from fitness-info.si"
  task :fitness_info => :environment do
    transformer = Import::FitnessInfoTransformer.new
    data_source = Import::FitnessInfoDatasource.new
    Import::Importer.new(data_source, transformer).run
  end

  task :fitnes_si => :environment do
    transformer = Import::FitnesSiTransformer.new
    data_source = Import::FitnesSiDatasource.new
    Import::Importer.new(data_source, transformer).run
  end

  task :slovenia_wellness => :environment do
    transformer = Import::SloveniaWellnessTransformer.new
    data_source = Import::SloveniaWellnessDatasource.new
    Import::Importer.new(data_source, transformer).run
  end

  task :fitness_info_wellness => :environment do
    transformer = Import::FitnessInfoWellnessTransformer.new
    data_source = Import::FitnessInfoWellnessDatasource.new
    Import::Importer.new(data_source, transformer).run
  end

  task :fitnes_si_new => :environment do
    transformer = Import::FitnesSiNewTransformer.new
    data_source = Import::FitnesSiNewDatasource.new
    Import::Importer.new(data_source, transformer).run
  end
end

