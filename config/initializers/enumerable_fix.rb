# patch to make everything work with ruby 1.8.7
# see http://old.teabass.com/undefined-method-for-enumerable/
unless '1.9'.respond_to?(:force_encoding)
  String.class_eval do
    begin
      remove_method :chars
    rescue NameError
      # OK
    end
  end
end