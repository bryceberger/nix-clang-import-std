export module foo;
import :hidden;
import std;

export auto fn() -> std::string_view { return "foo"; }

export auto get_hidden() { return hidden(); }
