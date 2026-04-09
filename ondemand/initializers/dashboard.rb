
src  = '/data/notebook_data'
dest = "#{ENV['HOME']}/jupyter_notebook_data"

unless File.directory?(dest)
  FileUtils.copy_entry src, dest
end
