namespace Valour.Shared.Models.Staff;

public class BulkDisableUsersRequest
{
    public long[] UserIds { get; set; }
    public bool Value { get; set; }
}
