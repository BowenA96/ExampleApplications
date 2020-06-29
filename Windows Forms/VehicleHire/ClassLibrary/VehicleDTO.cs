namespace ClassLibrary
{
    public class VehicleDTO
    {
        public long VehicleId { get; }
        public string Type { get; }
        public string Engine { get; }
        public string Gearbox { get; }
        public decimal PricePerDay { get; }
        public int NumberAvailable { get; }

        public VehicleDTO(long vehicleId, string type, string engine, string gearbox, decimal pricePerDay, int numberAvailable)
        {
            VehicleId = vehicleId;
            Type = type;
            Engine = engine;
            Gearbox = gearbox;
            PricePerDay = pricePerDay;
            NumberAvailable = numberAvailable;
        }

        public override string ToString()
        {
            return $"Type: {Type}, Engine: {Engine}, Gearbox: {Gearbox}, Price Per Day (10 Hours): {PricePerDay.ToString("c")}";
        }
    }
}