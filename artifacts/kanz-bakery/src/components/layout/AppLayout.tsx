import { Link, useLocation } from "wouter";
import { Wheat, Menu as MenuIcon, X } from "lucide-react";
import { useState } from "react";
import { Button } from "@/components/ui/button";

export function AppLayout({ children }: { children: React.ReactNode }) {
  const [location] = useLocation();
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const links = [
    { href: "/", label: "Home" },
    { href: "/menu", label: "Menu" },
    { href: "/catering", label: "Catering" },
    { href: "/about", label: "About Us" },
  ];

  return (
    <div className="min-h-[100dvh] flex flex-col">
      <header className="sticky top-0 z-50 w-full border-b bg-background/90 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto px-4 h-20 flex items-center justify-between">
          <Link href="/" className="flex items-center gap-2 text-primary hover:opacity-80 transition-opacity">
            <Wheat className="h-8 w-8" />
            <span className="font-serif text-2xl font-bold text-foreground">Kanz Bakery</span>
          </Link>
          
          <nav className="hidden md:flex gap-8">
            {links.map((link) => (
              <Link 
                key={link.href} 
                href={link.href}
                className={`text-sm font-medium uppercase tracking-wider transition-colors hover:text-primary ${
                  location === link.href ? "text-primary" : "text-muted-foreground"
                }`}
              >
                {link.label}
              </Link>
            ))}
          </nav>

          <Button 
            variant="ghost" 
            size="icon" 
            className="md:hidden text-foreground"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            {isMenuOpen ? <X className="h-6 w-6" /> : <MenuIcon className="h-6 w-6" />}
          </Button>
        </div>

        {/* Mobile menu */}
        {isMenuOpen && (
          <div className="md:hidden border-t bg-background absolute top-20 left-0 w-full shadow-lg">
            <nav className="flex flex-col p-4 gap-4">
              {links.map((link) => (
                <Link 
                  key={link.href} 
                  href={link.href}
                  className={`text-lg font-serif font-medium transition-colors hover:text-primary ${
                    location === link.href ? "text-primary" : "text-muted-foreground"
                  }`}
                  onClick={() => setIsMenuOpen(false)}
                >
                  {link.label}
                </Link>
              ))}
            </nav>
          </div>
        )}
      </header>

      <main className="flex-1 flex flex-col">
        {children}
      </main>

      <footer className="bg-foreground text-background py-16 mt-auto">
        <div className="container mx-auto px-4 grid grid-cols-1 md:grid-cols-3 gap-12">
          <div>
            <div className="flex items-center gap-2 text-background mb-6">
              <Wheat className="h-8 w-8" />
              <span className="font-serif text-2xl font-bold">Kanz Bakery</span>
            </div>
            <p className="text-muted/80 max-w-sm">
              A family-run neighborhood bakery dedicated to the craft of slow-fermented breads and artisanal pastries.
            </p>
          </div>
          <div>
            <h3 className="font-serif text-xl font-medium mb-6 text-primary-foreground">Visit Us</h3>
            <address className="not-italic text-muted/80 space-y-2">
              <p>124 Artisan Way</p>
              <p>Portland, OR 97204</p>
              <p className="pt-4">(503) 555-0199</p>
              <p>hello@kanzbakery.com</p>
            </address>
          </div>
          <div>
            <h3 className="font-serif text-xl font-medium mb-6 text-primary-foreground">Hours</h3>
            <ul className="text-muted/80 space-y-2">
              <li className="flex justify-between max-w-[200px]">
                <span>Mon - Fri</span>
                <span>6am - 4pm</span>
              </li>
              <li className="flex justify-between max-w-[200px]">
                <span>Saturday</span>
                <span>7am - 3pm</span>
              </li>
              <li className="flex justify-between max-w-[200px]">
                <span>Sunday</span>
                <span>7am - 2pm</span>
              </li>
            </ul>
          </div>
        </div>
        <div className="container mx-auto px-4 mt-16 pt-8 border-t border-muted/20 text-center text-muted/60 text-sm">
          &copy; {new Date().getFullYear()} Kanz Bakery. All rights reserved.
        </div>
      </footer>
    </div>
  );
}