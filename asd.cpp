#include <iostream>
#include <type_traits>

namespace Asd {
class Example {
public:
  Example() {}

private:
  int x;
};
} // namespace Asd

enum class Hello : int { One, Two, Three };

template <typename Enum> constexpr auto from_enum(Enum val) {
  return static_cast<std::underlying_type_t<Enum>>(val);
}

int main(int argc, char *argv[]) {

  std::string str = "asdsadasda";
  auto hello{Hello::Three};
  auto xd{from_enum(hello)};
  std::cout << xd << std::endl;
  return 0;
}
