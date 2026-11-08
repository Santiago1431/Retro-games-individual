namespace RetroGames.Repository;

public class RegistroDuplicadoException : Exception
{
    public RegistroDuplicadoException(string message, Exception? innerException = null) 
        : base(message, innerException)
    {
    }
}
