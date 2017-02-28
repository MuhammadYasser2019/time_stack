module ProjectsHelper
  def consultant_name(fname, lname)
    consultant_name = "Unknown Name"
    if fname.nil? || lname.nil?
      
    else
      consultant_name = "#{fname} #{lname}"
    end
    return consultant_name
  end
end
