using System.Data.Common;
using System.Text;
using RetroGames.Model.Model;

namespace RetroGames.Repository;

public class JogoRepository : RepositoryBase, IJogoRepository
{
    public JogoRepository(RepositoryConfig config) : base(config)
    {
    }

    public async Task<(List<Jogo> Jogos, int Total)> ListarAsync(
        string? busca = null, 
        int? idPlataforma = null, 
        List<int>? ids = null, 
        bool incluirInativos = false, 
        int pagina = 1, 
        int tamanhoPagina = 10)
    {
        await using var conexao = await AbrirConexaoAsync();

        var whereClause = new StringBuilder("WHERE 1=1");

        if (!incluirInativos)
        {
            whereClause.Append(" AND st_ativo = TRUE");
        }

        if (!string.IsNullOrWhiteSpace(busca))
        {
            whereClause.Append(" AND no_jogo LIKE @busca");
        }

        if (idPlataforma.HasValue)
        {
            whereClause.Append(" AND co_plataforma = @idPlataforma");
        }

        if (ids != null)
        {
            if (ids.Count == 0)
            {
                return (new List<Jogo>(), 0);
            }

            var paramNames = new List<string>();
            for (var i = 0; i < ids.Count; i++)
            {
                paramNames.Add($"@idFiltro{i}");
            }
            whereClause.Append($" AND co_seq_jogo IN ({string.Join(", ", paramNames)})");
        }

        // 1. Contagem total
        var sqlCount = $"SELECT COUNT(*) FROM tb_jogo {whereClause};";
        await using var comandoCount = CriarComando(conexao, sqlCount);
        ConfigurarParametros(comandoCount, busca, idPlataforma, ids);
        var total = Convert.ToInt32(await comandoCount.ExecuteScalarAsync());

        if (total == 0)
        {
            return (new List<Jogo>(), 0);
        }

        // 2. Consulta paginada
        var offset = Math.Max(0, (pagina - 1) * tamanhoPagina);
        var sqlSelect = $@"
            SELECT co_seq_jogo, no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, 
                   qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo 
            FROM tb_jogo 
            {whereClause} 
            ORDER BY no_jogo ASC 
            LIMIT @limite OFFSET @offset;";

        await using var comandoSelect = CriarComando(conexao, sqlSelect);
        ConfigurarParametros(comandoSelect, busca, idPlataforma, ids);
        AdicionarParametro(comandoSelect, "@limite", tamanhoPagina);
        AdicionarParametro(comandoSelect, "@offset", offset);

        await using var leitor = await comandoSelect.ExecuteReaderAsync();
        var jogos = new List<Jogo>();
        while (await leitor.ReadAsync())
        {
            jogos.Add(ConverterLinha(leitor));
        }

        return (jogos, total);
    }

    public async Task<Jogo?> BuscarPorIdAsync(int id)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            SELECT co_seq_jogo, no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, 
                   qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo 
            FROM tb_jogo 
            WHERE co_seq_jogo = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);
        await using var leitor = await comando.ExecuteReaderAsync();

        if (await leitor.ReadAsync())
        {
            return ConverterLinha(leitor);
        }

        return null;
    }

    public async Task<int> InserirAsync(Jogo jogo)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            INSERT INTO tb_jogo (no_jogo, ds_jogo, nu_ano_lancamento, vl_preco, qt_estoque, st_ativo, dt_cadastro, co_plataforma, co_condicao_jogo) 
            VALUES (@nome, @descricao, @anoLancamento, @preco, @estoque, @ativo, @dataCadastro, @idPlataforma, @idCondicaoJogo);";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@nome", jogo.Nome);
        AdicionarParametro(comando, "@descricao", jogo.Descricao);
        AdicionarParametro(comando, "@anoLancamento", jogo.AnoLancamento);
        AdicionarParametro(comando, "@preco", jogo.Preco);
        AdicionarParametro(comando, "@estoque", jogo.Estoque);
        AdicionarParametro(comando, "@ativo", jogo.Ativo);
        AdicionarParametro(comando, "@dataCadastro", jogo.DataCadastro);
        AdicionarParametro(comando, "@idPlataforma", jogo.IdPlataforma);
        AdicionarParametro(comando, "@idCondicaoJogo", jogo.IdCondicaoJogo);

        var idGerado = await ExecutarGravacaoAsync(comando);
        return Convert.ToInt32(idGerado);
    }

    public async Task AlterarAsync(Jogo jogo)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = @"
            UPDATE tb_jogo 
            SET no_jogo = @nome, 
                ds_jogo = @descricao, 
                nu_ano_lancamento = @anoLancamento, 
                vl_preco = @preco, 
                qt_estoque = @estoque, 
                st_ativo = @ativo, 
                co_plataforma = @idPlataforma, 
                co_condicao_jogo = @idCondicaoJogo 
            WHERE co_seq_jogo = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", jogo.Id);
        AdicionarParametro(comando, "@nome", jogo.Nome);
        AdicionarParametro(comando, "@descricao", jogo.Descricao);
        AdicionarParametro(comando, "@anoLancamento", jogo.AnoLancamento);
        AdicionarParametro(comando, "@preco", jogo.Preco);
        AdicionarParametro(comando, "@estoque", jogo.Estoque);
        AdicionarParametro(comando, "@ativo", jogo.Ativo);
        AdicionarParametro(comando, "@idPlataforma", jogo.IdPlataforma);
        AdicionarParametro(comando, "@idCondicaoJogo", jogo.IdCondicaoJogo);

        await ExecutarGravacaoAsync(comando);
    }

    public async Task DesativarAsync(int id)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = "UPDATE tb_jogo SET st_ativo = FALSE WHERE co_seq_jogo = @id;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@id", id);

        await comando.ExecuteNonQueryAsync();
    }

    private void ConfigurarParametros(MySqlConnector.MySqlCommand comando, string? busca, int? idPlataforma, List<int>? ids)
    {
        if (!string.IsNullOrWhiteSpace(busca))
        {
            AdicionarParametro(comando, "@busca", $"%{busca}%");
        }

        if (idPlataforma.HasValue)
        {
            AdicionarParametro(comando, "@idPlataforma", idPlataforma.Value);
        }

        if (ids != null)
        {
            for (var i = 0; i < ids.Count; i++)
            {
                AdicionarParametro(comando, $"@idFiltro{i}", ids[i]);
            }
        }
    }

    private static Jogo ConverterLinha(DbDataReader leitor)
    {
        return new Jogo
        {
            Id = leitor.GetInt32(leitor.GetOrdinal("co_seq_jogo")),
            Nome = leitor.GetString(leitor.GetOrdinal("no_jogo")),
            Descricao = leitor.IsDBNull(leitor.GetOrdinal("ds_jogo")) ? null : leitor.GetString(leitor.GetOrdinal("ds_jogo")),
            AnoLancamento = leitor.GetInt32(leitor.GetOrdinal("nu_ano_lancamento")),
            Preco = leitor.GetDecimal(leitor.GetOrdinal("vl_preco")),
            Estoque = leitor.GetInt32(leitor.GetOrdinal("qt_estoque")),
            Ativo = leitor.GetBoolean(leitor.GetOrdinal("st_ativo")),
            DataCadastro = leitor.GetDateTime(leitor.GetOrdinal("dt_cadastro")),
            IdPlataforma = leitor.GetInt32(leitor.GetOrdinal("co_plataforma")),
            IdCondicaoJogo = leitor.GetInt32(leitor.GetOrdinal("co_condicao_jogo"))
        };
    }
}
