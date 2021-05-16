# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Lint::ElseLayout, :config do
  it 'registers an offense and corrects for expr on same line as else' do
    expect_offense(<<~RUBY)
      if something
        test
      else ala
           ^^^ Odd `else` layout detected. Did you mean to use `elsif`?
        something
        test
      end
    RUBY

    expect_correction(<<~RUBY)
      if something
        test
      else
        ala
        something
        test
      end
    RUBY
  end

  it 'accepts proper else' do
    expect_no_offenses(<<~RUBY)
      if something
        test
      else
        something
        test
      end
    RUBY
  end

  it 'accepts single-expr else regardless of layout' do
    expect_no_offenses(<<~RUBY)
      if something
        test
      else bala
      end
    RUBY
  end

  it 'registers an offense and corrects for elsifs' do
    expect_offense(<<~RUBY)
      if something
        test
      elsif something
        bala
      else ala
           ^^^ Odd `else` layout detected. Did you mean to use `elsif`?
        something
        test
      end
    RUBY

    expect_correction(<<~RUBY)
      if something
        test
      elsif something
        bala
      else
        ala
        something
        test
      end
    RUBY
  end

  it 'registers and corrects an offense when using multiple `elsif`s' do
    expect_offense(<<~RUBY)
      if condition_foo
        foo
      elsif condition_bar
        bar
      elsif condition_baz
        baz
      else qux
           ^^^ Odd `else` layout detected. Did you mean to use `elsif`?
        quux
        corge
      end
    RUBY

    expect_correction(<<~RUBY)
      if condition_foo
        foo
      elsif condition_bar
        bar
      elsif condition_baz
        baz
      else
        qux
        quux
        corge
      end
    RUBY
  end

  it 'accepts ternary ops' do
    expect_no_offenses('x ? a : b')
  end

  it 'accepts modifier forms' do
    expect_no_offenses('x if something')
  end

  it 'accepts empty braces' do
    expect_no_offenses(<<~RUBY)
      if something
        ()
      else
        ()
      end
    RUBY
  end
end
