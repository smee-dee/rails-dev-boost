module RailsDevelopmentBoost
  module ReferenceCleanupPatch
    def self.apply!
      Module.send :include, self
      alias_method :remove_const_without_reference_cleanup, :remove_const
    end

    def remove_const(const_name)
      ActiveSupport::Dependencies::Reference.loose!(self == Object ? const_name : "#{_mod_name}::#{const_name}")
      ActiveSupport::DescendantsTracker.delete(const_get(const_name))
      remove_const_without_reference_cleanup(const_name)
    end
  end
end
