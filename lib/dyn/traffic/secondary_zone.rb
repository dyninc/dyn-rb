module Dyn
  module Traffic
    class SecondaryZone
      attr_accessor :contact_nickname, :masters, :tsig, :activate, :deactivate, :retransfer

      def initialize(dyn, zone, fqdn, contact_nickname, tsig_key_name, activate, deactivate, retransfer)
        @dyn = dyn
        @zone = zone
        @fqdn = fqdn
        @contact_nickname = contact_nickname
        @tsig_key_name = tsig_key_name  
        @activate = activate
        @deactivate = deactivate
        @retransfer = retransfer
      end

      def zone(value=nil)
        value ? (@zone = value; self) : @zone
      end

      def fqdn(value=nil)
        value ? (@fqdn = value; self) : @fqdn
      end

      def contact_nickname()
        value ? (@contact_nickname = value; self) : @contact_nickname
      end

      def tsig_key_name()
        value ? (@tsig_key_name = value; self) : @tsig_key_name
      end

      def activate()
        value ? (@activate = value; self) : @activate
      end
      
      def deactivate()
        value ? (@deactivate = value; self) : @deactivate
      end
      
      def retransfer()
        value ? (@retransfer = value; self) : @retransfer
      end

      def resource_path
        "Secondary"
      end

      def create(contact_nickname, masters, tsig)
        @dyn.create("#{resource_path}")
      end

      def get()
        @dyn.get("#{resource_path}")
      end

      def update(contact_nickname, masters, tsig)
        @dyn.update("#{resource_path}")
      end

      def activate(activate=true)
        @dyn.update("#{resource_path}")
      end

      def deactivate(deactivate=true)
        @dyn.update("#{resource_path}")
      end

      def retransfer(retransfer=true)
        @dyn.update("#{resource_path}")
      end

      def to_json
        {
          "zone" => @zone,
          "fqdn" => @fqdn,
          "contact_nickname" => @contact_nickname,
          "masters" => @masters,
          "tsig" => @tsig,
          "activate" => @activate,
          "deactivate" => @deactivate,
          "retransfer" => @retransfer
        }.to_json
      end
    end
  end
end
