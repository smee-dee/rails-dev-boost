module RailsDevelopmentBoost
  module ViewHelpersPatch
    def self.apply!
      AbstractController::Helpers::ClassMethods.send :include, self
    end

    # we need to explicitly associate helpers to their including controllers/mailers
    def add_template_helper(helper_module)
      if DependenciesPatch::Util.anonymous_const?(helper_module)
        helper_module.ancestors.each {|ancestor| ActiveSupport::Dependencies.add_explicit_dependency(ancestor, self)}
      else
        ActiveSupport::Dependencies.add_explicit_dependency(helper_module, self)
      end
      add_template_helper_without_const_association_tracking(helper_module)
    end

    def self.included(base)
      base.send(:alias_method, :add_template_helper_without_const_association_tracking, :add_template_helper)
    end
  end
end
