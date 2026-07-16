import { useCreateCateringRequest } from "@workspace/api-client-react";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { CalendarDays, Users, Phone, Mail, Loader2, CheckCircle2 } from "lucide-react";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage, FormDescription } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useState } from "react";

const cateringSchema = z.object({
  fullName: z.string().min(2, "Full name is required"),
  email: z.string().email("Invalid email address"),
  phone: z.string().min(10, "Valid phone number is required"),
  eventType: z.string().min(1, "Event type is required"),
  eventDate: z.string().min(1, "Event date is required"),
  guestCount: z.coerce.number().min(1, "Must have at least 1 guest"),
  itemsRequested: z.string().min(10, "Please describe what items you are looking for"),
  budgetRange: z.string().optional(),
  specialRequests: z.string().optional(),
});

export default function Catering() {
  const [isSubmitted, setIsSubmitted] = useState(false);
  
  const createRequest = useCreateCateringRequest({
    mutation: {
      onSuccess: () => {
        setIsSubmitted(true);
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    }
  });

  const form = useForm<z.infer<typeof cateringSchema>>({
    resolver: zodResolver(cateringSchema),
    defaultValues: {
      fullName: "",
      email: "",
      phone: "",
      eventType: "",
      eventDate: "",
      guestCount: 10,
      itemsRequested: "",
      budgetRange: "",
      specialRequests: "",
    },
  });

  if (isSubmitted) {
    return (
      <div className="min-h-screen bg-amber-50/30 flex items-center justify-center py-20 px-4">
        <div className="bg-card max-w-lg w-full p-10 rounded-2xl border shadow-lg text-center animate-in fade-in zoom-in duration-500">
          <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <CheckCircle2 className="h-10 w-10 text-green-600" />
          </div>
          <h2 className="font-serif text-4xl font-bold mb-4">Request Received!</h2>
          <p className="text-lg text-muted-foreground mb-8">
            Thank you for considering Kanz Bakery for your event. Our team will review your request and get back to you within 24-48 hours to discuss details and finalize a quote.
          </p>
          <Button onClick={() => setIsSubmitted(false)} variant="outline" className="font-serif">
            Submit Another Request
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-amber-50/30 pb-24">
      {/* Hero Section */}
      <div className="bg-primary text-primary-foreground py-20 px-4 relative overflow-hidden">
        <div className="absolute inset-0 opacity-10 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMiIgY3k9IjIiIHI9IjIiIGZpbGw9IiNmZmYiLz48L3N2Zz4=')] [background-size:20px_20px]" />
        <div className="container mx-auto max-w-4xl text-center relative z-10">
          <h1 className="font-serif text-5xl md:text-6xl font-bold mb-6">Catering & Bulk Orders</h1>
          <p className="text-xl text-primary-foreground/90 max-w-2xl mx-auto font-light leading-relaxed">
            Elevate your next gathering with artisanal breads, delicate pastries, and custom creations made fresh from scratch.
          </p>
        </div>
      </div>

      <div className="container mx-auto max-w-6xl px-4 mt-12 grid md:grid-cols-3 gap-12">
        
        {/* Info Column */}
        <div className="md:col-span-1 space-y-8">
          <div className="bg-card p-8 rounded-xl border shadow-sm">
            <h3 className="font-serif text-2xl font-bold mb-4">How it works</h3>
            <ol className="space-y-6 relative border-l-2 border-primary/20 ml-3 pl-6">
              <li className="relative">
                <span className="absolute -left-[35px] bg-primary text-white w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold">1</span>
                <strong className="block text-foreground mb-1">Submit Request</strong>
                <p className="text-muted-foreground text-sm">Fill out the form with your event details and what you're craving.</p>
              </li>
              <li className="relative">
                <span className="absolute -left-[35px] bg-primary text-white w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold">2</span>
                <strong className="block text-foreground mb-1">Consultation</strong>
                <p className="text-muted-foreground text-sm">We'll review your request and finalize the menu and quote within 48 hours.</p>
              </li>
              <li className="relative">
                <span className="absolute -left-[35px] bg-primary text-white w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold">3</span>
                <strong className="block text-foreground mb-1">Bake & Deliver</strong>
                <p className="text-muted-foreground text-sm">We bake everything fresh for your event day. Pickup or delivery available.</p>
              </li>
            </ol>
          </div>

          <div className="bg-amber-100/50 p-8 rounded-xl border border-amber-200">
            <h3 className="font-serif text-xl font-bold mb-4 text-amber-900">Please Note</h3>
            <ul className="space-y-3 text-amber-800 text-sm">
              <li className="flex gap-2">
                <span className="font-bold">•</span>
                We require at least 72 hours notice for all catering and bulk orders.
              </li>
              <li className="flex gap-2">
                <span className="font-bold">•</span>
                Minimum order amount for delivery is $150.
              </li>
              <li className="flex gap-2">
                <span className="font-bold">•</span>
                Custom cakes require a minimum of 1 week notice.
              </li>
            </ul>
          </div>
        </div>

        {/* Form Column */}
        <div className="md:col-span-2">
          <div className="bg-card rounded-2xl border shadow-sm p-8 md:p-10">
            <h2 className="font-serif text-3xl font-bold mb-8 border-b pb-4">Request a Quote</h2>
            
            <Form {...form}>
              <form onSubmit={form.handleSubmit((data) => createRequest.mutate({ data }))} className="space-y-8">
                
                {/* Contact Info */}
                <div className="space-y-6">
                  <h3 className="font-serif text-xl font-medium text-primary">Contact Information</h3>
                  <div className="grid md:grid-cols-2 gap-6">
                    <FormField
                      control={form.control}
                      name="fullName"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Full Name</FormLabel>
                          <FormControl>
                            <Input placeholder="Jane Doe" {...field} />
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="email"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Email Address</FormLabel>
                          <FormControl>
                            <div className="relative">
                              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                              <Input type="email" placeholder="jane@example.com" className="pl-9" {...field} />
                            </div>
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="phone"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Phone Number</FormLabel>
                          <FormControl>
                            <div className="relative">
                              <Phone className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                              <Input type="tel" placeholder="(555) 123-4567" className="pl-9" {...field} />
                            </div>
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>
                </div>

                {/* Event Details */}
                <div className="space-y-6 pt-6 border-t">
                  <h3 className="font-serif text-xl font-medium text-primary">Event Details</h3>
                  <div className="grid md:grid-cols-2 gap-6">
                    <FormField
                      control={form.control}
                      name="eventType"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Event Type</FormLabel>
                          <Select onValueChange={field.onChange} defaultValue={field.value}>
                            <FormControl>
                              <SelectTrigger>
                                <SelectValue placeholder="Select event type" />
                              </SelectTrigger>
                            </FormControl>
                            <SelectContent>
                              <SelectItem value="corporate">Corporate Meeting / Event</SelectItem>
                              <SelectItem value="wedding">Wedding</SelectItem>
                              <SelectItem value="birthday">Birthday Party</SelectItem>
                              <SelectItem value="wholesale">Wholesale / Café Supply</SelectItem>
                              <SelectItem value="other">Other Gathering</SelectItem>
                            </SelectContent>
                          </Select>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="eventDate"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Event Date</FormLabel>
                          <FormControl>
                            <div className="relative">
                              <CalendarDays className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                              <Input type="date" className="pl-9" {...field} />
                            </div>
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="guestCount"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Estimated Guest Count</FormLabel>
                          <FormControl>
                            <div className="relative">
                              <Users className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                              <Input type="number" min="1" className="pl-9" {...field} />
                            </div>
                          </FormControl>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                    <FormField
                      control={form.control}
                      name="budgetRange"
                      render={({ field }) => (
                        <FormItem>
                          <FormLabel>Budget Range (Optional)</FormLabel>
                          <Select onValueChange={field.onChange} defaultValue={field.value}>
                            <FormControl>
                              <SelectTrigger>
                                <SelectValue placeholder="Select budget range" />
                              </SelectTrigger>
                            </FormControl>
                            <SelectContent>
                              <SelectItem value="under-150">Under $150</SelectItem>
                              <SelectItem value="150-300">$150 - $300</SelectItem>
                              <SelectItem value="300-500">$300 - $500</SelectItem>
                              <SelectItem value="500-1000">$500 - $1,000</SelectItem>
                              <SelectItem value="over-1000">Over $1,000</SelectItem>
                            </SelectContent>
                          </Select>
                          <FormMessage />
                        </FormItem>
                      )}
                    />
                  </div>
                </div>

                {/* Order Details */}
                <div className="space-y-6 pt-6 border-t">
                  <h3 className="font-serif text-xl font-medium text-primary">Order Details</h3>
                  
                  <FormField
                    control={form.control}
                    name="itemsRequested"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>What would you like to order?</FormLabel>
                        <FormDescription>
                          Be as specific or general as you like (e.g. "2 dozen assorted croissants and a large fruit tart" or "Breakfast pastries for 50 people")
                        </FormDescription>
                        <FormControl>
                          <Textarea 
                            placeholder="Describe your ideal menu..." 
                            className="min-h-[120px]" 
                            {...field} 
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                  
                  <FormField
                    control={form.control}
                    name="specialRequests"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Dietary Restrictions & Special Requests</FormLabel>
                        <FormControl>
                          <Textarea 
                            placeholder="Allergies, delivery instructions, theme colors..." 
                            className="min-h-[80px]" 
                            {...field} 
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <Button type="submit" size="lg" className="w-full font-serif text-lg py-6 h-auto" disabled={createRequest.isPending}>
                  {createRequest.isPending && <Loader2 className="mr-2 h-5 w-5 animate-spin" />}
                  Submit Catering Request
                </Button>
              </form>
            </Form>
          </div>
        </div>
      </div>
    </div>
  );
}