# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Draper

  CollectionDecorator.delegate :current_page, :total_pages, :limit_value, :total_count

  module Linker

    module ClassMethods

      def links (*names)
        names.each do |name|
          define_method("#{name}_link") do
            link_if(__send__(name))
          end
        end
      end

    end

    def self.included (klass)
      klass.extend ClassMethods
    end

    def link_if (item, name = item && item.name)
      item ? h.link_to(name, item) : h.content_tag(:span, "(None)", class: "subdue")
    end

  end

end
