import { Heart, Clock, Utensils } from "lucide-react";
import aboutImg from "@assets/generated_images/about.jpg";

export default function About() {
  return (
    <div className="min-h-screen bg-amber-50/30">
      {/* Hero Section */}
      <section className="relative py-24 md:py-32 px-4 overflow-hidden bg-foreground text-background">
        <div className="container mx-auto max-w-4xl text-center relative z-10">
          <h1 className="font-serif text-5xl md:text-7xl font-bold mb-6">Our Story</h1>
          <p className="text-xl text-background/80 font-light leading-relaxed max-w-2xl mx-auto">
            Born from a simple belief: the best bread takes time, and the best moments happen around a shared table.
          </p>
        </div>
      </section>

      {/* Main Content */}
      <section className="py-20 px-4 container mx-auto max-w-5xl">
        <div className="grid md:grid-cols-2 gap-12 items-center mb-24">
          <div className="relative">
            <div className="aspect-[4/5] rounded-2xl overflow-hidden shadow-2xl rotate-[-2deg] transition-transform hover:rotate-0 duration-500 border-8 border-white">
              <img 
                src={aboutImg} 
                alt="Baker dusting flour" 
                className="w-full h-full object-cover"
              />
            </div>
            <div className="absolute -bottom-6 -right-6 bg-primary text-primary-foreground p-6 rounded-full w-32 h-32 flex items-center justify-center rotate-12 shadow-lg">
              <span className="font-handwriting text-2xl text-center leading-tight">Since<br/>1984</span>
            </div>
          </div>
          
          <div className="space-y-6">
            <h2 className="font-serif text-4xl font-bold text-foreground">It started with a single starter.</h2>
            <p className="text-lg text-muted-foreground leading-relaxed">
              Back in 1984, our founder Maria started baking bread in her tiny apartment kitchen. She had one simple rule: no shortcuts. Water, flour, salt, and time.
            </p>
            <p className="text-lg text-muted-foreground leading-relaxed">
              That original sourdough starter—which we affectionately call "The Beast"—is still alive today. It's the mother of every single loaf of sourdough we bake.
            </p>
            <p className="text-lg text-muted-foreground leading-relaxed">
              When we opened our doors to the neighborhood, we didn't just want to sell bread. We wanted to create a third space. A place between work and home where you know the barista's name, and they know your usual order.
            </p>
          </div>
        </div>

        {/* Values */}
        <div className="bg-card rounded-3xl p-12 shadow-xl border">
          <div className="text-center mb-12">
            <h2 className="font-serif text-3xl md:text-4xl font-bold mb-4">Our Philosophy</h2>
            <div className="w-24 h-1 bg-primary mx-auto rounded-full" />
          </div>
          
          <div className="grid md:grid-cols-3 gap-12 text-center">
            <div className="flex flex-col items-center">
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mb-6 text-amber-700">
                <Clock className="h-8 w-8" />
              </div>
              <h3 className="font-serif text-xl font-bold mb-3">Time is an Ingredient</h3>
              <p className="text-muted-foreground">
                We never rush fermentation. Our breads take up to 48 hours to develop their complex flavors and digestible structures.
              </p>
            </div>
            
            <div className="flex flex-col items-center">
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mb-6 text-amber-700">
                <Utensils className="h-8 w-8" />
              </div>
              <h3 className="font-serif text-xl font-bold mb-3">Local & Seasonal</h3>
              <p className="text-muted-foreground">
                We mill our own heritage grains sourced from local farmers. If a fruit isn't in season, you won't find it in our tarts.
              </p>
            </div>
            
            <div className="flex flex-col items-center">
              <div className="w-16 h-16 bg-amber-100 rounded-full flex items-center justify-center mb-6 text-amber-700">
                <Heart className="h-8 w-8" />
              </div>
              <h3 className="font-serif text-xl font-bold mb-3">Community First</h3>
              <p className="text-muted-foreground">
                At the end of each day, all unsold bread is donated to local food banks. We believe good food is a right, not a luxury.
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}