import { useGetMenuItem, useListMenuItemReviews, useCreateMenuItemReview, getGetMenuItemQueryKey, getListMenuItemReviewsQueryKey } from "@workspace/api-client-react";
import { Link, useRoute } from "wouter";
import { Star, ArrowLeft, Loader2, MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useToast } from "@/hooks/use-toast";
import { useQueryClient } from "@tanstack/react-query";
import { format } from "date-fns";

const reviewSchema = z.object({
  authorName: z.string().min(1, "Name is required"),
  rating: z.number().min(1).max(5),
  comment: z.string().optional(),
});

export default function MenuItemDetail() {
  const [, params] = useRoute("/menu/:id");
  const id = Number(params?.id);
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: item, isLoading: isLoadingItem, error } = useGetMenuItem(id, {
    query: { enabled: !!id, queryKey: getGetMenuItemQueryKey(id) }
  });

  const { data: reviews, isLoading: isLoadingReviews } = useListMenuItemReviews(id, {
    query: { enabled: !!id, queryKey: getListMenuItemReviewsQueryKey(id) }
  });

  const createReview = useCreateMenuItemReview({
    mutation: {
      onSuccess: () => {
        toast({ title: "Review submitted!", description: "Thank you for your feedback." });
        form.reset({ authorName: "", rating: 5, comment: "" });
        queryClient.invalidateQueries({ queryKey: getListMenuItemReviewsQueryKey(id) });
        queryClient.invalidateQueries({ queryKey: getGetMenuItemQueryKey(id) });
      },
      onError: () => {
        toast({ title: "Error", description: "Failed to submit review. Please try again.", variant: "destructive" });
      }
    }
  });

  const form = useForm<z.infer<typeof reviewSchema>>({
    resolver: zodResolver(reviewSchema),
    defaultValues: {
      authorName: "",
      rating: 5,
      comment: "",
    },
  });

  if (isLoadingItem) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-amber-50/30">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (error || !item) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-amber-50/30 text-center px-4">
        <h2 className="font-serif text-3xl font-bold mb-4 text-foreground">Item Not Found</h2>
        <p className="text-muted-foreground mb-8">The menu item you are looking for does not exist or has been removed.</p>
        <Button asChild>
          <Link href="/menu">Back to Menu</Link>
        </Button>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-amber-50/30 pb-24 pt-8">
      <div className="container mx-auto max-w-4xl px-4">
        <Link href="/menu" className="inline-flex items-center text-sm font-medium text-muted-foreground hover:text-primary mb-8 transition-colors">
          <ArrowLeft className="h-4 w-4 mr-2" /> Back to Menu
        </Link>

        <div className="bg-card rounded-2xl border shadow-sm overflow-hidden mb-12">
          <div className="md:flex">
            <div className="md:w-1/2 p-8 md:p-12 flex flex-col justify-center border-b md:border-b-0 md:border-r bg-white">
              <div className="mb-4">
                <span className="text-primary font-medium tracking-widest uppercase text-xs">{item.category}</span>
              </div>
              <h1 className="font-serif text-4xl md:text-5xl font-bold text-foreground mb-4 leading-tight">
                {item.name}
              </h1>
              <p className="text-lg text-muted-foreground leading-relaxed mb-8">
                {item.description}
              </p>
              
              <div className="flex items-end gap-4 mt-auto">
                <div className="text-4xl font-serif font-bold text-foreground">
                  ${item.price.toFixed(2)}
                </div>
              </div>
            </div>
            
            <div className="md:w-1/2 p-8 md:p-12 flex flex-col bg-amber-50/20">
              <h3 className="font-serif text-2xl font-bold mb-6 flex items-center gap-2">
                <Star className="h-6 w-6 text-amber-400 fill-amber-400" />
                Rating & Reviews
              </h3>
              
              <div className="bg-card rounded-xl border p-6 mb-8 text-center shadow-sm">
                {item.averageRating ? (
                  <>
                    <div className="text-5xl font-serif font-bold text-foreground mb-2">
                      {item.averageRating.toFixed(1)}
                    </div>
                    <div className="flex justify-center gap-1 mb-2">
                      {[1, 2, 3, 4, 5].map((star) => (
                        <Star 
                          key={star} 
                          className={`h-5 w-5 ${star <= Math.round(item.averageRating!) ? 'fill-amber-400 text-amber-400' : 'text-muted fill-muted'}`} 
                        />
                      ))}
                    </div>
                    <div className="text-sm text-muted-foreground">Based on {item.reviewCount} reviews</div>
                  </>
                ) : (
                  <div className="py-4">
                    <MessageCircle className="h-8 w-8 mx-auto text-muted-foreground opacity-50 mb-3" />
                    <p className="text-muted-foreground font-medium">No reviews yet</p>
                    <p className="text-sm text-muted-foreground">Be the first to review this item!</p>
                  </div>
                )}
              </div>

              <div className="mt-auto">
                <h4 className="font-serif font-bold text-lg mb-4">Write a Review</h4>
                <Form {...form}>
                  <form onSubmit={form.handleSubmit((data) => createReview.mutate({ id, data }))} className="space-y-4">
                    
                    <FormField
                      control={form.control}
                      name="rating"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Rating</FormLabel>
                          <FormControl>
                            <div className="flex gap-2">
                              {[1, 2, 3, 4, 5].map((star) => (
                                <button
                                  type="button"
                                  key={star}
                                  onClick={() => field.onChange(star)}
                                  className="focus:outline-none transition-transform hover:scale-110"
                                >
                                  <Star 
                                    className={`h-8 w-8 ${star <= field.value ? 'fill-amber-400 text-amber-400' : 'text-muted fill-muted hover:text-amber-200 hover:fill-amber-200'}`} 
                                  />
                                </button>
                              ))}
                            </div>
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />

                    <FormField
                      control={form.control}
                      name="authorName"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Your Name</FormLabel>
                          <FormControl>
                            <Input placeholder="Jane Doe" {...field} className="bg-background" />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    
                    <FormField
                      control={form.control}
                      name="comment"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Comment <span className="text-muted-foreground font-normal">(optional)</span></FormLabel>
                          <FormControl>
                            <Textarea 
                              placeholder="What did you think of it?" 
                              className="resize-none bg-background" 
                              {...field} 
                            />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    
                    <Button type="submit" className="w-full" disabled={createReview.isPending}>
                      {createReview.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                      Submit Review
                    </Button>
                  </form>
                </Form>
              </div>
            </div>
          </div>
        </div>

        <div>
          <h2 className="font-serif text-3xl font-bold mb-8">Customer Reviews</h2>
          
          {isLoadingReviews ? (
            <div className="space-y-6">
              {[1, 2, 3].map(i => (
                <div key={i} className="bg-card rounded-xl border p-6 animate-pulse">
                  <div className="flex justify-between mb-4">
                    <div className="h-5 bg-muted rounded w-32" />
                    <div className="h-4 bg-muted rounded w-24" />
                  </div>
                  <div className="h-4 bg-muted rounded w-full mb-2" />
                  <div className="h-4 bg-muted rounded w-2/3" />
                </div>
              ))}
            </div>
          ) : reviews && reviews.length > 0 ? (
            <div className="space-y-6">
              {reviews.map((review) => (
                <div key={review.id} className="bg-card rounded-xl border p-6 shadow-sm">
                  <div className="flex justify-between items-start mb-4">
                    <div>
                      <div className="font-bold text-foreground text-lg mb-1">{review.authorName}</div>
                      <div className="flex gap-0.5">
                        {[1, 2, 3, 4, 5].map((star) => (
                          <Star 
                            key={star} 
                            className={`h-4 w-4 ${star <= review.rating ? 'fill-amber-400 text-amber-400' : 'text-muted fill-muted'}`} 
                          />
                        ))}
                      </div>
                    </div>
                    <div className="text-sm text-muted-foreground">
                      {format(new Date(review.createdAt), 'MMM d, yyyy')}
                    </div>
                  </div>
                  {review.comment && (
                    <p className="text-muted-foreground leading-relaxed italic">"{review.comment}"</p>
                  )}
                </div>
              ))}
            </div>
          ) : (
             <p className="text-muted-foreground text-lg py-8">Be the first to leave a review!</p>
          )}
        </div>
      </div>
    </div>
  );
}