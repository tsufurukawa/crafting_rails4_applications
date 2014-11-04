module MailForm
  class Base
    include ActiveModel::Conversion
    include ActiveModel::AttributeMethods
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Validations

    attribute_method_prefix 'clear_'
    attribute_method_suffix '?'

    class_attribute :attribute_names
    self.attribute_names = []

    def self.attributes(*names)
      attr_accessor(*names)
      define_attribute_methods(names)

      self.attribute_names += names
    end

    def initialize(attributes={})
      attributes.each { |attr, value| self.public_send("#{attr}=", value) } if attributes
    end

    include MailForm::Validators

    # Add callbacks behavior
    extend ActiveModel::Callbacks

    # Define the callbacks with the same semantics as in ActiveRecord
    define_model_callbacks :deliver

    # Run the callbacks
    def deliver
      # "valid?" method is given to us by ActiveModel::Validations
      if valid?
        run_callbacks(:deliver) do
          MailForm::Notifier.contact(self).deliver # this 'deliver' is from ActionMailer::Base
        end
      else
        false
      end
    end

    def persisted?
      false
    end

    protected

    # Since we declared a "clear_" prefix, it expected to have a "clear_attribute" method 
    # defined, which receives an attribute name and impelements the clearing logic
    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end

    # Implement the logic required by the '?' suffix
    def attribute?(attribute)
      send(attribute).present?
    end
  end
end