defmodule Game.ColorTest do
  use ExUnit.Case
  doctest Game.Color

  alias Game.Color
  alias Game.ColorCodes

  import Game.Color, only: [format: 1, format: 2]

  test "replaces multiple colors" do
    assert format("{black}word{/black} {blue}word{/blue}") == "\e[30mword\e[0m \e[34mword\e[0m"
  end

  test "replaces black" do
    assert format("{black}word{/black}") == "\e[30mword\e[0m"
  end

  test "replaces red" do
    assert format("{red}word{/red}") == "\e[31mword\e[0m"
  end

  test "replaces green" do
    assert format("{green}word{/green}") == "\e[32mword\e[0m"
  end

  test "replaces yellow" do
    assert format("{yellow}word{/yellow}") == "\e[33mword\e[0m"
  end

  test "replaces blue" do
    assert format("{blue}word{/blue}") == "\e[34mword\e[0m"
  end

  test "replaces magenta" do
    assert format("{magenta}word{/magenta}") == "\e[35mword\e[0m"
  end

  test "replaces cyan" do
    assert format("{cyan}word{/cyan}") == "\e[36mword\e[0m"
  end

  test "replaces white" do
    assert format("{white}word{/white}") == "\e[37mword\e[0m"
  end

  test "replaces map colors" do
    assert format("{map:blue}\\[ \\]{/map:blue}") == "\e[38;5;26m[ ]\e[0m"
  end

  test "replaces map colors - dark green" do
    assert format("{map:dark-green}\\[ \\]{/map:dark-green}") == "\e[38;5;22m[ ]\e[0m"
  end

  describe "state machine" do
    test "replaces a color after another color is reset" do
      assert format("{green}hi there {white}command{/white} green again{/green}") ==
        "\e[32mhi there \e[37mcommand\e[32m green again\e[0m"
    end

    test "handles larger text" do
      text =
        """
        {blue}Player{/blue} is here. {yellow}Guard{/yellow} ({yellow}!{/yellow}) is idling around.
        Exits: {white}north{/white}, {white}south{/white}

        {blue}This is a more {cyan}complicated{/cyan} line than the other one {green}many colors{/green}{/blue}
        """

      expected =
        """
        \e[34mPlayer\e[0m is here. \e[33mGuard\e[0m (\e[33m!\e[0m) is idling around.
        Exits: \e[37mnorth\e[0m, \e[37msouth\e[0m

        \e[34mThis is a more \e[36mcomplicated\e[34m line than the other one \e[32mmany colors\e[34m\e[0m
        """

      assert format(text) == expected
    end

    test "does nothing if there is an invalid set of tags" do
      assert format("{green}hi there {white}command{/white} green again") ==
        "{green}hi there {white}command{/white} green again"
    end
  end

  describe "configure the colors" do
    test "players can configure semantic colors" do
      config = %{color_npc: "green"}

      assert format("{npc}Guard{/npc}", config) == "\e[32mGuard\e[0m"
    end
  end

  describe "handles dynamic colors" do
    setup do
      ColorCodes.reload(%{key: "new-white", ansi_escape: "\\e[38;2;255;255;255;m"})

      :ok
    end

    test "converts dynamic colors" do
      assert format("{new-white}hi there {/new-white}") == "\e[38;2;255;255;255;mhi there \e[0m"
    end
  end

  describe "delinks" do
    test "removes commands" do
      string = Color.delink_commands("{command}help colors{/command}")
      assert string == "{command click=false}help colors{/command}"
    end

    test "removes links" do
      string = Color.delink_commands("{link}http://example.com{/link}")
      assert string == "{link click=false}http://example.com{/link}"
    end
  end
end
