namespace Valour.Shared.Models.Staff;

public class BulkActionResult
{
    public int SuccessCount { get; set; }
    public List<BulkActionFailure> Failures { get; set; } = new();
}

public class BulkActionFailure
{
    public long UserId { get; set; }
    public string Message { get; set; }
}
