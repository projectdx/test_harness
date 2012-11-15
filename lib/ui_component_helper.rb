class MissingConfiguration < Exception; end

class TestHarness
  module UIComponentHelper
    def mm
      TestHarness.mm
    end

    def component
      self.class.parent.component
    end

    def reset
      @form = nil
    end

    def configuration
      TestHarness.configuration
    end

    def browser
      @browser ||= begin
        raise MissingConfiguration.new('TestHarness.browser must be defined') if configuration.browser.nil?
        configuration.browser
       end
    end

    # If the UIComponent is sent a message it does not understand, it will
    # forward that message on to its {#browser} but wrap the call in a block
    # provided to the the browser's `#within` method. This provides convenient
    # access to the browser driver's DSL, automatically scoped to this
    # component.
    def method_missing(name, *args, &block)
      if respond_to?(name)
        browser.within(component.within) do
          browser.send(name, *args, &block)
        end
      else
        super
      end
    end

    # Since Kernel#select is defined, we have to override it specifically here.
    def select(*args, &block)
      browser.within(component.within) do
        browser.select(*args, &block)
      end
    end

    # We don't want to go through the method_missing above for visit, but go
    # directly to the browser object
    def visit(path)
      path = "%s:%s%s" % [server_host, Capybara.server_port, path] if path !~ /^http/

      browser.visit(path)
    end

    def show!
      visit component_path
    end

    # Used to submit elements set by the *form* method
    # In the UIDriver, you can use:
    #   form.username = 'user@email.com'
    #   form.password = 'password'
    #   form.yes = true    # for checkbox
    #   form.radio1 = true # for radio button
    #
    #   submit!
    #
    def submit!
      form_hash.each do |k,v|
        field = find_field(k.to_s)
        field[:type] =~ /^select/ ? field.select(v) : field.set(v)
      end

      if has_css?(locator = component.submit)
        find(:css, component.submit).click
      else
        click_on component.submit
      end
    end

    # Used to set form elements for submittal by the method submit!
    # In the UIDriver, you can use:
    #   form.username = 'user@email.com'
    #   form.password = 'password'
    #   submit!
    def form
      @form ||= OpenStruct.new
    end

    private
    def form_hash
      form.instance_variable_get("@table")
    end

    private
    def component_path
      component.path.gsub(/:\w+/) {|match| mm.subject.send(match.tr(':',''))}
    end

    # @private
    # (Not really private, but YARD seemingly lacks RDoc's :nodoc tag, and the
    # semantics here don't differ from Object#respond_to?)
    def respond_to?(name)
      super || browser.respond_to?(name)
    end

    def server_host
      configuration.server_host || Capybara.default_host || 'http://example.com'
    end
  end
end
