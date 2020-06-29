namespace ClassLibrary
{
    public class EquipmentDTO
    {
        public long EquipmentId { get; }
        public string Type { get; }
        public int Amount { get; }

        public EquipmentDTO (long equipmentId, string type, int amount)
        {
            EquipmentId = equipmentId;
            Type = type;
            Amount = amount;
        }

        public override string ToString()
        {
            return $"Type: {Type}";
        }
    }
}