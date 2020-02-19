module AresMUSH
  module Traits
    class SetTraitCmd
      include CommandHandler

      # "category" added to imitate 'relationships' for categorized traits
      attr_accessor :name, :trait_name, :category, :description
            
      def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          
          self.name = enactor_name
          self.trait_name = titlecase_arg(args.arg1)
          self.category = titlecase_arg(args.arg2)
          self.description = args.arg3
      end
      
      def required_args
        [ self.name, self.trait_name, self.category, self.description ]
      end

     # Locks trait editing if approved
      def check_chargen_locked
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (enactor.name == model.name || Chargen.can_approve?(enactor))
            traits = model.traits || {}
            # trying to add multiple values to trait, including not-yet-set order
            traits[self.trait_name] = { :category => self.category, :description => self.description, :order => order } 
            model.update(traits: traits)
            client.emit_success t('traits.trait_set')
          else
            client.emit_failure t('dispatcher.not_allowed')
          end
                    
        end
      end
    end
  end
end
