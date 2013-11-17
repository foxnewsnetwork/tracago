materials = [
  {
    name: "PET",
    description: "Number 1. Polyethylene Terephthalate, PETs are clear, tough, solvent resistant; they are often used to make bottles, trays, etc."
  },
  {
    name: "PE-HD",
    description: "Number 2. High Density Polyethylene, HDPEs are hard, resistant, but softens at around 75C. Used in bottles, trays, etc."
  },
  {
    name: "PVC",
    description: "Number 3. Polyvinyl Chloride. Strong, touch. Used for piping, containers, etc."
  },
  {
    name: "PE-LD",
    description: "Number 4. Low Density Polyethylene, LDPEs are soft, flexible, and usually translucent. Used for wraps, bags, etc."
  },
  {
    name: "PP",
    description: "Number 5. Polypropylene. PPs are tough and used in somewhat high temperature applications like lunch boxes."
  },
  {
    name: "PS",
    description: "Number 6. Polystyrene. Clear, glass, rigid, and brittle. Used in things like CDs, video cases, and plastic windows."
  },
  {
    name: "Other",
    description: "Number 7. Other plastics like SAN, ABS, PC, PVC, etc. Used for everything else."
  }
]

materials.each do |material|
  Spree::Material.create! material
end