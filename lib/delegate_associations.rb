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

		except = [options[:except]].flatten.compact.map!(&:to_sym)
		only  = [options[:only]].flatten.compact.map!(&:to_sym)
		except += delegate_exclude_columns

		associations.each do |association|
			reflect_on_association(association).klass.reflect_on_all_associations.each do |ass|
				next unless ass.name.in?(get_deletage_methods(reflect_on_association(association).klass.reflect_on_all_associations.map(&:name), except, only))
				delegate "#{ass.name}",  to: association, allow_nil: options[:allow_nil]
				delegate "#{ass.name}=", to: association, allow_nil: options[:allow_nil]
				begin 
					delegate "#{ass.name}_attributes=", to: association, allow_nil: options[:allow_nil]
				rescue
					true
				end
				
				unless ass.collection?
					delegate "build_#{ass.name}", to: association
				end
			end
		end
	end

	def delegate_attributes(*opts)
		options = {
			suffix: ["","=","?","_before_type_cast","_change","_changed?","_was","_will_change!"], 
			except: [], only: [], allow_nil: false, to: [], prefix: nil
		}
		options.update(opts.extract_options!)
		associations = [options.delete(:to)].flatten.compact.map!(&:to_sym)

		#Valid if have an option[:to] and if association exists
		valid_associations_to(associations)

		except  = [options[:except]].flatten.compact.map!(&:to_sym)
		only    = [options[:only]].flatten.compact.map!(&:to_sym)
		prefix  = options[:prefix]
		except += delegate_exclude_columns
		
		# I need "begin" because have a problem with Devise when I run migrations
		# Devise call User classs before run all migrations
		begin
			associations.each do |association|
				get_deletage_methods(reflect_on_association(association).klass.column_names, except, only).each do |attribute| 
					options[:suffix].each do |sf|
						delegate "#{attribute}#{sf}", to: association, allow_nil: options[:allow_nil], prefix: prefix
					end
				end
			end
		rescue
			true
		end
	end

	private

	def get_deletage_methods(all_options, except, only)
		return (all_options.map(&:to_sym)&only)-delegate_exclude_columns if only.any?
		all_options.map(&:to_sym) - except
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