import { useListMenuCategories, useListMenuItems } from "@workspace/api-client-react";
import { Link, useLocation } from "wouter";
import { useState, useMemo } from "react";
import { Star, Search, Coffee } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";

export default function Menu() {
  const [search, setSearch] = useState("");
  const [activeCategory, setActiveCategory] = useState<string | null>(null);
  
  const { data: categories, isLoading: isLoadingCategories } = useListMenuCategories();
  
  // We fetch all and filter client-side for immediate feedback, 
  // but could also use the category param if we preferred server-side filtering
  const { data: menuItems, isLoading: isLoadingItems } = useListMenuItems();

  const filteredItems = useMemo(() => {
    if (!menuItems) return [];
    return menuItems.filter(item => {
      const matchesSearch = item.name.toLowerCase().includes(search.toLowerCase()) || 
                           item.description.toLowerCase().includes(search.toLowerCase());
      const matchesCategory = activeCategory ? item.category === activeCategory : true;
      return matchesSearch && matchesCategory;
    });
  }, [menuItems, search, activeCategory]);

  return (
    <div className="min-h-screen bg-amber-50/30 pb-24">
      {/* Header */}
      <div className="bg-foreground text-background py-16 px-4">
        <div className="container mx-auto max-w-6xl text-center">
          <h1 className="font-serif text-5xl md:text-6xl font-bold mb-4">Our Menu</h1>
          <p className="text-muted/80 max-w-2xl mx-auto text-lg">
            Baked fresh every morning. Come early for the best selection, 
            or place a special order to guarantee your favorites.
          </p>
        </div>
      </div>

      <div className="container mx-auto max-w-6xl px-4 mt-8 flex flex-col md:flex-row gap-8">
        
        {/* Sidebar Filters */}
        <div className="md:w-64 shrink-0 space-y-8">
          <div className="space-y-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input 
                placeholder="Search menu..." 
                className="pl-9 bg-background"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
          </div>

          <div className="space-y-4">
            <h3 className="font-serif text-xl font-bold">Categories</h3>
            {isLoadingCategories ? (
              <div className="space-y-2">
                {[1, 2, 3, 4].map(i => (
                  <div key={i} className="h-10 bg-muted animate-pulse rounded-md" />
                ))}
              </div>
            ) : (
              <div className="flex flex-col gap-1">
                <Button 
                  variant={activeCategory === null ? "default" : "ghost"}
                  className="justify-start w-full font-medium"
                  onClick={() => setActiveCategory(null)}
                >
                  All Items
                </Button>
                {categories?.map((cat) => (
                  <Button 
                    key={cat.name}
                    variant={activeCategory === cat.name ? "default" : "ghost"}
                    className="justify-between w-full font-medium"
                    onClick={() => setActiveCategory(cat.name)}
                  >
                    <span>{cat.name}</span>
                    <Badge variant="secondary" className="ml-2 bg-muted">{cat.itemCount}</Badge>
                  </Button>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Menu Grid */}
        <div className="flex-1">
          {isLoadingItems ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
              {[1, 2, 3, 4, 5, 6].map((i) => (
                <div key={i} className="rounded-xl overflow-hidden bg-card animate-pulse border p-6 flex flex-col h-full gap-4">
                  <div className="h-6 bg-muted rounded w-3/4" />
                  <div className="h-4 bg-muted rounded w-full" />
                  <div className="h-4 bg-muted rounded w-1/2" />
                  <div className="mt-auto pt-4 flex justify-between">
                    <div className="h-6 bg-muted rounded w-16" />
                    <div className="h-6 bg-muted rounded w-16" />
                  </div>
                </div>
              ))}
            </div>
          ) : filteredItems.length === 0 ? (
            <div className="text-center py-24 bg-card rounded-xl border border-dashed">
              <Coffee className="h-12 w-12 text-muted-foreground mx-auto mb-4 opacity-50" />
              <h3 className="text-xl font-serif font-bold text-foreground mb-2">No items found</h3>
              <p className="text-muted-foreground">Try adjusting your search or category filter.</p>
              <Button 
                variant="outline" 
                className="mt-6"
                onClick={() => { setSearch(""); setActiveCategory(null); }}
              >
                Clear Filters
              </Button>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredItems.map((item, index) => (
                <Link key={item.id} href={`/menu/${item.id}`} className="group h-full flex">
                  <div className="bg-card rounded-xl border shadow-sm transition-all duration-300 hover:shadow-md hover:border-primary/50 p-6 flex flex-col w-full relative overflow-hidden">
                    {item.isFeatured && (
                      <div className="absolute top-0 right-0">
                        <div className="bg-primary text-primary-foreground text-[10px] font-bold uppercase tracking-wider px-3 py-1 rounded-bl-lg">
                          Featured
                        </div>
                      </div>
                    )}
                    
                    <div className="flex justify-between items-start mb-3 gap-4">
                      <h3 className="font-serif text-xl font-bold group-hover:text-primary transition-colors leading-tight">
                        {item.name}
                      </h3>
                    </div>
                    
                    <p className="text-muted-foreground text-sm flex-1 leading-relaxed mb-6">
                      {item.description}
                    </p>
                    
                    <div className="flex items-center justify-between mt-auto pt-4 border-t border-muted">
                      <span className="font-bold text-lg text-foreground">${item.price.toFixed(2)}</span>
                      
                      {item.averageRating ? (
                        <div className="flex items-center gap-1 text-sm">
                          <Star className="h-4 w-4 fill-amber-400 text-amber-400" />
                          <span className="font-medium text-foreground">{item.averageRating.toFixed(1)}</span>
                          <span className="text-muted-foreground">({item.reviewCount})</span>
                        </div>
                      ) : (
                        <span className="text-xs text-muted-foreground italic">New</span>
                      )}
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}