require 'detroit/tool'

module Detroit

  # RONN Tool
  #
  class Ronn < Tool

    # Default manpage directoy.
    DEFAULT_DIRECTORY = 'man'

    # Not that this is necessary, but ...
    #def self.available?(project)
    #  begin
    #    require 'ronn'
    #    true
    #  rescue LoadError
    #    false
    #  end
    #end

    # Name of the manual (top-center).
    attr_accessor :title

    # Published date in YYYY-MM-DD format (bottom-center).
    attr_accessor :date

    # Make sure data is in the YYYY-MM-DD format.
    def date=(date)
      @date = Time.parse(date).strftime('%Y-%M-%D')
    end

    # Publishing group or individual (bottom-left).
    attr_accessor :organization

    # Alias for #organization.
    alias_accessor :org, :organization

    # Location of `.ronn` files, defaults to `man`.
    attr_accessor :folder

    # Alias for #folder.
    alias_accessor :output, :folder

    # Generate man pages.
    #
    # @todo Can we do this in code instead of shelling out?
    def generate
      argv = []
      argv << %[ronn]
      argv << %[--date="#{date}"]
      argv << %[--manual="#{manual}"]
      argv << %[--organization="#{organiation}"]

      sh argv.join(' ')

      # report ""
    end

    # Mark man pages as out-of-date.
    #
    # TODO: Implement reset.
    #
    #def reset
    #end

    # Remove generated man pages.
    #
    # TODO: Implement clean.
    #
    #def clean
    #end

    #  A S S E M B L Y  M E T H O D S

    # Assemble on `generate` phase.
    def assemble?(station, options={})
      case station
      when :generate then true
      end
    end

    # It's important to update the manifest before other generators, so
    # this plugs into the :pre_generate phase.
    def assemble(station, options={})
      case station
      when :generate then generate
      end
    end

  private

    #
    def initialize_requires
      require 'ronn'
    end

    #
    def initialize_defaults
      @date         = Time.now.strftime('%Y-%M-%D')
      @title        = project.metadata.title
      @organization = project.metadata.organization
      @folder       = DEFUALT_DIRECTORY
    end

    #
    def options
      { :title        => title,
        :date         => date,
        :organization => organization,
        :folder       => folder
      }
    end

  end

end

