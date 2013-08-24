class TrueClass
  def to_s(style = :boolean)
    case style
      when :word then I18n.t('yep')
      when :Word then I18n.t('yep')
      when :number then '1'
      else 'true'
    end
  end
end
 
class FalseClass
  def to_s(style = :boolean)
    case style
      when :word then I18n.t('nope')
      when :Word then I18n.t('nope')
      when :number then '0'
      else 'false'
    end
  end
end

