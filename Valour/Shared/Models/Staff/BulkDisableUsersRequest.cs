namespace Valour.Shared.Models.Staff;

public class BulkDisableUsersRequest
{
    public List<long> UserIds { get; set; }
    public bool Value { get; set; }
}
