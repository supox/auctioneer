module I18n
  class << self
    alias :__translate :translate #  move the current self.translate() to self.__translate()
    def translate(key, options = {})
      if key.class == TrueClass || key.class == FalseClass
        return key ? self.__translate("yes", options) : self.__translate("no", options)
      else
        return self.__translate(key, options)
      end
    end
  end
end

