module IdeeliSpinup
class Classifier
  IClassify = 1 

  def self.get ( type, options = {} )
    case type
      when IClassify then IdeeliSpinup::Classifiers::IClassify.new(options)
    end
  end
end
end
