using RetroGames.Model.Model;

namespace RetroGames.Repository;

public class PlataformaRepository : RepositoryBase, IPlataformaRepository
{
    public PlataformaRepository(RepositoryConfig config) : base(config)
    {
    }

    public async Task<List<Plataforma>> ListarAsync()
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            SELECT co_seq_plataforma, no_plataforma, no_fabricante, nu_ano_lancamento 
            FROM tb_plataforma 
            ORDER BY no_plataforma ASC;";

        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var plataformas = new List<Plataforma>();
        while (await leitor.ReadAsync())
        {
            plataformas.Add(ConverterLinha(leitor));
        }

        return plataformas;
    }

    public async Task<Plataforma?> BuscarPorIdAsync(int id)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            SELECT co_seq_plataforma, no_plataforma, no_fabricante, nu_ano_lancamento 
            FROM tb_plataforma 
            WHERE co_seq_plataforma = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);
        await using var leitor = await comando.ExecuteReaderAsync();

        if (await leitor.ReadAsync())
        {
            return ConverterLinha(leitor);
        }

        return null;
    }

    public async Task<bool> ExisteComNomeAsync(string nome, int? idIgnorar = null)
    {
        await using var conexao = await AbrirConexaoAsync();
        var sql = @"
            SELECT COUNT(*) 
            FROM tb_plataforma 
            WHERE no_plataforma = @nome";

        if (idIgnorar.HasValue)
        {
            sql += " AND co_seq_plataforma <> @idIgnorar";
        }

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", nome);
        if (idIgnorar.HasValue)
        {
            AdicionarParametro(comando, "@idIgnorar", idIgnorar.Value);
        }

        var count = Convert.ToInt64(await comando.ExecuteScalarAsync());
        return count > 0;
    }

    public async Task<bool> PossuiJogosAsync(int id)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            SELECT COUNT(*) 
            FROM tb_jogo 
            WHERE co_plataforma = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);

        var count = Convert.ToInt64(await comando.ExecuteScalarAsync());
        return count > 0;
    }

    public async Task<int> InserirAsync(Plataforma plataforma)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            INSERT INTO tb_plataforma (no_plataforma, no_fabricante, nu_ano_lancamento) 
            VALUES (@nome, @fabricante, @anoLancamento);";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", plataforma.Nome);
        AdicionarParametro(comando, "@fabricante", plataforma.Fabricante);
        AdicionarParametro(comando, "@anoLancamento", plataforma.AnoLancamento);

        var idGerado = await ExecutarGravacaoAsync(comando);
        return Convert.ToInt32(idGerado);
    }

    public async Task AlterarAsync(Plataforma plataforma)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            UPDATE tb_plataforma 
            SET no_plataforma = @nome, 
                no_fabricante = @fabricante, 
                nu_ano_lancamento = @anoLancamento 
            WHERE co_seq_plataforma = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", plataforma.Id);
        AdicionarParametro(comando, "@nome", plataforma.Nome);
        AdicionarParametro(comando, "@fabricante", plataforma.Fabricante);
        AdicionarParametro(comando, "@anoLancamento", plataforma.AnoLancamento);

        await ExecutarGravacaoAsync(comando);
    }

    public async Task ExcluirAsync(int id)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = "DELETE FROM tb_plataforma WHERE co_seq_plataforma = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);

        await comando.ExecuteNonQueryAsync();
    }

    private static Plataforma ConverterLinha(System.Data.Common.DbDataReader leitor)
    {
        return new Plataforma
        {
            Id = leitor.GetInt32(leitor.GetOrdinal("co_seq_plataforma")),
            Nome = leitor.GetString(leitor.GetOrdinal("no_plataforma")),
            Fabricante = leitor.GetString(leitor.GetOrdinal("no_fabricante")),
            AnoLancamento = leitor.GetInt32(leitor.GetOrdinal("nu_ano_lancamento"))
        };
    }
}
