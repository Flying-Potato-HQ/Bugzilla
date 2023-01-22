# frozen_string_literal: true

module Bugzilla
  class Tracer
    module Handlers
      def tally_by(keyword)
        # @events.map(&:event).tally
        @events.map { |e| e.send(keyword) }.tally
      end

      def tally_overview
        # find unique object_ids
        keys = @events.map(&:object_id).uniq
        res = []
        keys.each do |key|
          { key => @events.select { |e| e.object_id == key }.map {  |obj|
            res << {
                self: obj.itself.to_s, class: obj.defined_class, object_id: obj.object_id,
                method: obj.method_id, return_value: obj.return_value, instance_vars: obj.instance_vars,
                binding: obj.cached_binding }
            }
          }
        end

        res
      end

      def where_attr(attr, value, comparison = :==)
        @events.select {|e| e.send(attr).send(comparison, value) }
      end

      def where_attr_not(attr, value, comparison = :==)
        @events.select {|e| !e.send(attr).send(comparison, value) }
      end

      def where_attr_in(attr, values, comparison = :==)
        @events.select {|e| values.include?(e.send(attr).send(comparison)) }
      end

      def where_attr_present(attr)
        @events.select {|e| e.send(attr)&.present? }
      end

      def with_ivar(var_name)
        puts "var_name: #{var_name}"
        var_name = var_name + "@" unless var_name.start_with?("@")
        var_name = var_name.to_sym

        SearchResults.new(
          @events.select {|e| e.instance_vars.keys.include?(var_name) }
        )
      end
    end
  end
end


