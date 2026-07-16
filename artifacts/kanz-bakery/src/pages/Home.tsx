import { Link } from "wouter";
import { Button } from "@/components/ui/button";
import { useListMenuItems } from "@workspace/api-client-react";
import { ArrowRight, Star, Clock, Heart } from "lucide-react";
import heroImg from "@assets/generated_images/hero.jpg";
import sourdoughImg from "@assets/generated_images/sourdough.jpg";
import croissantImg from "@assets/generated_images/croissant.jpg";

export default function Home() {
  const { data: featuredItems, isLoading } = useListMenuItems({ featured: true });

  return (
    <div className="flex flex-col w-full">
      {/* Hero Section */}
      <section className="relative h-[80vh] min-h-[600px] w-full flex items-center justify-center overflow-hidden">
        <div className="absolute inset-0 z-0">
          <img 
            src={heroImg} 
            alt="Warm bakery interior with fresh bread" 
            className="w-full h-full object-cover object-center"
          />
          <div className="absolute inset-0 bg-black/40" />
        </div>
        <div className="relative z-10 text-center text-white px-4 max-w-4xl mx-auto flex flex-col items-center animate-in fade-in slide-in-from-bottom-8 duration-1000">
          <span className="font-handwriting text-3xl md:text-5xl text-amber-300 mb-4 tracking-wider rotate-[-2deg]">Since 1984</span>
          <h1 className="font-serif text-5xl md:text-7xl lg:text-8xl font-bold mb-6 leading-tight drop-shadow-lg">
            Baked with love,<br/>daily.
          </h1>
          <p className="text-lg md:text-xl text-white/90 mb-10 max-w-2xl font-light">
            We are a family-run neighborhood bakery crafting slow-fermented breads, delicate pastries, and custom cakes with the finest ingredients.
          </p>
          <div className="flex flex-col sm:flex-row gap-4">
            <Button asChild size="lg" className="text-lg px-8 py-6 h-auto font-serif">
              <Link href="/menu">Browse Our Menu</Link>
            </Button>
            <Button asChild variant="outline" size="lg" className="text-lg px-8 py-6 h-auto bg-white/10 text-white border-white/30 hover:bg-white hover:text-foreground font-serif backdrop-blur-sm">
              <Link href="/catering">Catering & Events</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* Chalkboard Intro */}
      <section className="py-20 px-4 bg-amber-50/50">
        <div className="container mx-auto max-w-6xl">
          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div className="chalkboard p-8 md:p-12 rotate-[-1deg] transform transition-transform hover:rotate-0 duration-500">
              <h2 className="font-handwriting text-4xl text-amber-200 mb-6 text-center">Today's Specials</h2>
              <ul className="space-y-4 font-handwriting text-2xl tracking-wide">
                <li className="flex justify-between border-b border-white/20 pb-2">
                  <span>Olive & Rosemary Boule</span>
                  <span>$8.50</span>
                </li>
                <li className="flex justify-between border-b border-white/20 pb-2">
                  <span>Pistachio Croissant</span>
                  <span>$5.25</span>
                </li>
                <li className="flex justify-between border-b border-white/20 pb-2">
                  <span>Cardamom Morning Bun</span>
                  <span>$4.75</span>
                </li>
                <li className="flex justify-between border-b border-white/20 pb-2">
                  <span>Seasonal Fruit Galette</span>
                  <span>$6.00</span>
                </li>
              </ul>
              <p className="text-center text-sm font-sans mt-8 text-white/60 uppercase tracking-widest">
                While supplies last!
              </p>
            </div>
            
            <div className="space-y-6 md:pl-8">
              <div className="flex gap-4 mb-2">
                <Clock className="h-6 w-6 text-primary" />
                <Heart className="h-6 w-6 text-primary" />
              </div>
              <h2 className="font-serif text-4xl font-bold text-foreground leading-tight">
                Slow food,<br/>made for fast friends.
              </h2>
              <p className="text-lg text-muted-foreground leading-relaxed">
                At Kanz Bakery, we don't rush the process. Our sourdough starter has been alive longer than our lead baker, and every croissant takes three days to make.
              </p>
              <p className="text-lg text-muted-foreground leading-relaxed">
                We believe that the best moments in life happen around a table, sharing something warm and delicious. That's why we're here, every morning before the sun comes up.
              </p>
              <Button asChild variant="link" className="px-0 text-primary text-lg font-serif mt-4">
                <Link href="/about" className="flex items-center gap-2">
                  Read our story <ArrowRight className="h-5 w-5" />
                </Link>
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Featured Items Grid */}
      <section className="py-24 px-4 container mx-auto">
        <div className="text-center mb-16">
          <span className="text-primary font-medium tracking-widest uppercase text-sm mb-2 block">Neighborhood Favorites</span>
          <h2 className="font-serif text-4xl md:text-5xl font-bold">Featured Bakes</h2>
        </div>

        {isLoading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[1, 2, 3].map((i) => (
              <div key={i} className="rounded-lg overflow-hidden bg-card animate-pulse border">
                <div className="h-64 bg-muted" />
                <div className="p-6 space-y-4">
                  <div className="h-6 bg-muted rounded w-3/4" />
                  <div className="h-4 bg-muted rounded w-full" />
                  <div className="h-4 bg-muted rounded w-1/2" />
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {featuredItems?.map((item, index) => (
              <Link key={item.id} href={`/menu/${item.id}`} className="group block">
                <div className="bg-card rounded-xl overflow-hidden border shadow-sm transition-all duration-300 hover:shadow-xl hover:-translate-y-1">
                  <div className="aspect-[4/3] overflow-hidden bg-muted relative">
                    {/* Fallback mock images based on category since API might not have real images yet */}
                    <img 
                      src={index % 2 === 0 ? sourdoughImg : croissantImg} 
                      alt={item.name}
                      className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                    />
                    <div className="absolute top-4 right-4 bg-background/90 backdrop-blur px-3 py-1 rounded-full text-sm font-medium shadow-sm">
                      ${item.price.toFixed(2)}
                    </div>
                  </div>
                  <div className="p-6">
                    <div className="flex justify-between items-start mb-3">
                      <h3 className="font-serif text-xl font-bold group-hover:text-primary transition-colors">{item.name}</h3>
                    </div>
                    <p className="text-muted-foreground line-clamp-2 mb-4 text-sm leading-relaxed">
                      {item.description}
                    </p>
                    {item.averageRating && (
                      <div className="flex items-center gap-1.5 text-sm text-muted-foreground">
                        <Star className="h-4 w-4 fill-amber-400 text-amber-400" />
                        <span className="font-medium text-foreground">{item.averageRating.toFixed(1)}</span>
                        <span>({item.reviewCount} reviews)</span>
                      </div>
                    )}
                  </div>
                </div>
              </Link>
            ))}
          </div>
        )}
        
        <div className="text-center mt-16">
          <Button asChild variant="outline" size="lg" className="font-serif">
            <Link href="/menu">View Full Menu</Link>
          </Button>
        </div>
      </section>

      {/* Catering CTA */}
      <section className="py-24 px-4 bg-primary text-primary-foreground relative overflow-hidden">
        {/* Decorative elements */}
        <div className="absolute top-0 left-0 w-full h-full opacity-10" 
             style={{ backgroundImage: `radial-gradient(circle at 2px 2px, white 1px, transparent 0)`, backgroundSize: '32px 32px' }} />
             
        <div className="container mx-auto max-w-4xl text-center relative z-10">
          <h2 className="font-serif text-4xl md:text-5xl font-bold mb-6">Need a lot of good bread?</h2>
          <p className="text-lg md:text-xl text-primary-foreground/90 mb-10 max-w-2xl mx-auto font-light">
            From morning meetings to wedding receptions, we offer bulk ordering and custom catering packages for your special events.
          </p>
          <Button asChild size="lg" className="bg-background text-primary hover:bg-background/90 text-lg px-8 py-6 h-auto font-serif shadow-lg">
            <Link href="/catering">Inquire About Catering</Link>
          </Button>
        </div>
      </section>
    </div>
  );
}