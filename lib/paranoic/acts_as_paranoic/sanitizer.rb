module Paranoic
  module ActsAsParanoic
    class Sanitizer

      def sanitize! user, params, resource
        puts resource
        # Gets params that will be sanitized.
        params = params[resource]

        # Deletes from resource suffixes like :attributes and :ids
        class_name = get_resource_class(resource)

        # Returns an array with the allowed attributes for user and resource
        # that were passed by param.
        params_allowed = attributes_allowed_for(user, class_name)

        if params.is_a?(Hash)
          sanitize_params_for(user, params, params_allowed)
        end

        if params.is_a?(Array)
          params.each do |params_item|
            if params_item.is_a?(Hash)
              sanitize_params_for(user, params_item, params_allowed)
            end
          end
        end
      end

      private

      # Removes the params that are not allowed. Removes keys that are not
      # included in attributes_allowed for the user.
      def sanitize_params_for user, params, params_allowed
        params.each do |key, val|
          if params_allowed.include?(key)
            sanitize!(user, params, key) if key =~ /_attributes|_ids$/
          else
            params.delete(key)
          end
        end
      end

      # Gets the class name to this resource. Removes 'attributes' and 'ids'.
      def get_resource_class resource
        resource_class = resource.to_s.gsub(/_attributes|_ids$/, "")
        resource_class.singularize.camelcase
      end

      # Gets the attributes allowed for the user and resource passed by param.
      # The attributes allowed should be in the attribute_permissions table in
      # the database.
      #
      # THIS METHOD NEEDS A REFACTOR.
      def attributes_allowed_for user, resource
        user.roles.includes(:attribute_permissions).
          map(&:attribute_permissions).flatten.
          select{ |e| e.class_name == resource && e.bin == 2 }.
          map{ |e| e.attribute_name.to_sym }
      end

    end
  end
end
