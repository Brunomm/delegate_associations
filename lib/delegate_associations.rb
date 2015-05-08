require 'active_record'
require 'active_record/version'


module DelegateAssociations

	def delegate_associations(*opts)
		options = {
			except: [], only: [], allow_nil: false, to: []
		}
		options.update(opts.extract_options!)
		associations = [options.delete(:to)].flatten.compact.map!(&:to_sym)
		valid_associations_to(associations)

		exept = [options[:exept]].flatten.compact.map!(&:to_sym)
		only  = [options[:only]].flatten.compact.map!(&:to_sym)
		exept += delegate_exclude_columns

		associations.each do |association|
			reflect_on_association(association).klass.reflect_on_all_associations.each do |ass|
				next unless ass.name.in?(get_deletage_methods(reflect_on_association(association).klass.reflect_on_all_associations.map(&:name), exept, only))
				if ass.collection?
					delegate "#{ass.name}", to: association, allow_nil: options[:allow_nil]
					delegate "#{ass.name}=", to: association, allow_nil: options[:allow_nil]
				else
					delegate "#{ass.name}", to: association
					delegate "#{ass.name}=", to: association
					delegate "build_#{ass.name}", to: association
				end
			end
		end
	end

	def delegate_attributes(*opts)
		options = {
			suffix: ["","=","?","_before_type_cast","_change","_changed?","_was","_will_change!"], 
			except: [], only: [], allow_nil: false, to: []
		}
		options.update(opts.extract_options!)
		associations = [options.delete(:to)].flatten.compact.map!(&:to_sym)

		#Valid if have an option[:to] and if association exists
		valid_associations_to(associations)

		exept = [options[:exept]].flatten.compact.map!(&:to_sym)
		only  = [options[:only]].flatten.compact.map!(&:to_sym)
		exept += delegate_exclude_columns
		
		associations.each do |association|
			get_deletage_methods(reflect_on_association(association).klass.column_names, exept, only).each do |attribute| 
					puts "#{options[:suffix]}"
				options[:suffix].each do |sf|
					delegate "#{attribute}#{sf}", to: association, allow_nil: options[:allow_nil]
				end
			end
		end
	end

	private

	def get_deletage_methods(all_options, exept, only)
		return (all_options.map(&:to_sym)&only)-delegate_exclude_columns if only.any?
		all_options.map(&:to_sym) - exept
	end

	def valid_associations_to(associations)
		raise ":to options can't be blank!" if associations.blank?
		associations.each do |association|
			raise "#{name} don't have the association #{association}" unless reflect_on_association(association)
		end
	end

	def delegate_exclude_columns
		[:id, :created_at, :updated_at]
	end
end

if defined?(ActiveRecord::Base)
	ActiveRecord::Base.extend DelegateAssociations
end