module AresMUSH  

  module Migrations
    class MigrationBeta67Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add CG system config."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        config['chargen']['ability_system'] = 'fs3'
        config['chargen']['ability_system_app_review_header'] = 'Abilities (help abilities)'
        DatabaseMigrator.write_config_file("chargen.yml", config)

        Global.logger.debug "Add web tag color."
        config = DatabaseMigrator.read_config_file("describe.yml")
        config['describe']['tag_colors']['web'] = '%xh%xx'
        DatabaseMigrator.write_config_file("describe.yml", config)
      end 
    end
  end
end