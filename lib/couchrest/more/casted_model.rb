require File.join(File.dirname(__FILE__), '..', 'mixins', 'properties')

module CouchRest
  module CastedModel
    
    def self.included(base)
      base.send(:include, CouchRest::Mixins::Properties)
      base.send(:attr_accessor, :casted_by)
      base.send(:attr_accessor, :document_saved)
    end
    
    def initialize(keys={})
      raise StandardError unless self.is_a? Hash
      apply_defaults # defined in CouchRest::Mixins::Properties
      super()
      keys.each do |k,v|
        self[k.to_s] = v
      end if keys
      cast_keys      # defined in CouchRest::Mixins::Properties
    end
    
    def []= key, value
      super(key.to_s, value)
    end
    
    def [] key
      super(key.to_s)
    end
    
    # False if the casted model has already
    # been saved in the containing document
    def new_model?
      !@document_saved
    end
    alias :new_record? :new_model?
    
    # Sets the attributes from a hash
    def update_attributes_without_saving(hash)
      hash.each do |k, v|
        raise NoMethodError, "#{k}= method not available, use property :#{k}" unless self.respond_to?("#{k}=")
      end      
      hash.each do |k, v|
        self.send("#{k}=",v)
      end
    end
    alias :attributes= :update_attributes_without_saving
    
  end
end
