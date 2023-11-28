class Gtksourceview5AT413 < Formula
    desc "Text view with syntax, undo/redo, and text marks"
    homepage "https://projects.gnome.org/gtksourceview/"
    url "https://download.gnome.org/sources/gtksourceview/5.10/gtksourceview-5.10.0.tar.xz"
    sha256 "b38a3010c34f59e13b05175e9d20ca02a3110443fec2b1e5747413801bc9c23f"
    license "LGPL-2.1-or-later"
  
    livecheck do
      url :stable
      regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
    end
  
  
    depends_on "gobject-introspection" => :build
    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "pkg-config" => [:build, :test]
    depends_on "vala" => :build
    depends_on "malleefoul/versions/gtk4@4.13"
    depends_on "pcre2"
    keg_only "versioned formula (AAAAAAAAA)"
  
    def install
      args = std_meson_args + %w[
        -Dintrospection=enabled
        -Dvapi=true
      ]
  
      mkdir "build" do
        system "meson", *args, ".."
        system "ninja", "-v"
        system "ninja", "install", "-v"
      end
    end
  
    test do
      (testpath/"test.c").write <<~EOS
        #include <gtksourceview/gtksource.h>
  
        int main(int argc, char *argv[]) {
          gchar *text = gtk_source_utils_unescape_search_text("hello world");
          return 0;
        }
      EOS
      flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceview-5").strip.split
      system ENV.cc, "test.c", "-o", "test", *flags
      system "./test"
    end
  end